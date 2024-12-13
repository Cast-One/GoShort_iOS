//
//  PremiumViewController+FetchPlans.swift
//  GoShortApp
//

import UIKit

extension PremiumViewController {
    
    func fetchPlanAgreements(token: String, completion: @escaping (Bool) -> Void) {
        let agreementEndpoint = APIManager.Endpoint(
            path: "/plans/agreement/",
            method: .GET,
            parameters: nil,
            headers: ["Authorization": "Bearer \(token)", "Accept": "application/json"]
        )

        APIManager.shared.request(endpoint: agreementEndpoint, responseType: PlanAgreementResponse.self) { result in
            switch result {
            case .success(let response):
                if response.success {
                    let agreements = response.data.plan_agreements
                    UserDefaultsManager.shared.saveUserPlanAgreements(agreements)
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure(_):
                completion(false)
            }
        }
    }

    func getUserPlanAgreements() -> [PlanAgreement] {
        if let data = UserDefaults.standard.data(forKey: "userPlanAgreements") {
            let decoder = JSONDecoder()
            do {
                return try decoder.decode([PlanAgreement].self, from: data)
            } catch {}
        }
        return []
    }

    @objc func subscribeTapped() {
        guard let token = UserDefaultsManager.shared.getAccessToken() else {
            return
        }

        self.showLoader()
        
        let requestBody: [String: String] = ["plan_id": premiumPlanID]
        let createAgreementEndpoint = APIManager.Endpoint(
            path: "/plans/agreement/",
            method: .POST,
            parameters: nil,
            headers: ["Authorization": "Bearer \(token)", "Accept": "application/json"]
        )
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            self.hideLoader()
            return
        }
        
        APIManager.shared.request(endpoint: createAgreementEndpoint, responseType: PlanAgreementCreationResponse.self, body: bodyData) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.success {
                    self.fetchPlanAgreements(token: token) { success in
                        DispatchQueue.main.async {
                            self.hideLoader()
                            if success {
                                self.delegate?.didBecomePremium(controller: self)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.hideLoader()
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.hideLoader()
                }
            }
        }
    }
}
