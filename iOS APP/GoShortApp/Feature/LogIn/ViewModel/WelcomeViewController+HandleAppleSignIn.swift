//
//  WelcomeViewController+HandleAppleSignIn.swift
//  GoShortApp
//

import UIKit
import AuthenticationServices

extension WelcomeViewController {
    
    @objc func handleAppleSignIn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

     func registerOrLogin(username: String, email: String, password: String) {
        self.showLoader()
         
        let registerEndpoint = APIManager.Endpoint(
            path: "/users/",
            method: .POST,
            parameters: ["username": username, "email": email, "password": password],
            headers: ["Accept": "application/json"]
        )
        
        APIManager.shared.request(endpoint: registerEndpoint, responseType: RegisterResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                if response.success {
                    self?.login(username: username, password: password)
                } else if response.message == "Username already registered" {
                    self?.login(username: username, password: password)
                } else {
                    self?.hideLoader()
                    self?.showError("Error: \(response.message)")
                }
            case .failure(let error):
                self?.hideLoader()
                self?.showError("Error al registrar: \(error.localizedDescription)")
            }
        }
    }

    private func login(username: String, password: String) {
        let loginEndpoint = APIManager.Endpoint(
            path: "/token?username=\(username)&password=\(password)",
            method: .POST,
            parameters: nil,
            headers: ["Accept": "application/json"]
        )

        APIManager.shared.request(endpoint: loginEndpoint, responseType: LoginResponse.self, body: nil) { [weak self] result in
            switch result {
            case .success(let response):
                if response.success {
                    let token = response.data.access_token
                    self?.fetchUserData(token: token) // Llamar a fetchUserData
                } else {
                    self?.hideLoader()
                    self?.showError("Error: \(response.message)")
                }
            case .failure(_):
                self?.hideLoader()
                self?.showError("No se pudo iniciar sesión. Verifica tus credenciales.")
            }
        }
    }

    private func fetchUserData(token: String) {
        let bearerToken = "Bearer \(token)"
        
        let userDataEndpoint = APIManager.Endpoint(
            path: "/users/me/",
            method: .GET,
            parameters: nil,
            headers: [
                "Authorization": bearerToken,
                "Accept": "application/json"
            ]
        )

        APIManager.shared.request(endpoint: userDataEndpoint, responseType: UserDataResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                if response.success {
                    let user = response.data
                    self?.saveUserToUserDefaults(user: user, token: token)
                    self?.fetchPlanAgreements(token: token) { success in
                        if success {
                            DispatchQueue.main.async {
                                self?.navigateToMainScreen()
                            }
                        } else {
                            self?.hideLoader()
                            self?.showError("Error al obtener los acuerdos del usuario.")
                        }
                    }
                } else {
                    self?.hideLoader()
                    self?.showError("Error al obtener datos del usuario: \(response.message)")
                }
            case .failure(_):
                self?.hideLoader()
                self?.showError("No se pudo obtener la información del usuario.")
            }
        }
    }


    private func fetchPlanAgreements(token: String, completion: @escaping (Bool) -> Void) {
        let agreementEndpoint = APIManager.Endpoint(
            path: "/plans/agreement/",
            method: .GET,
            parameters: nil,
            headers: ["Authorization": "Bearer \(token)", "Accept": "application/json"]
        )

        APIManager.shared.request(endpoint: agreementEndpoint, responseType: PlanAgreementResponse.self) { [weak self] result in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self?.hideLoader()
            }
            switch result {
            case .success(let response):
                if response.success {
                    self?.saveUserToUserDefaults(user: UserDefaultsManager.shared.getUser(), token: token, agreements: response.data.plan_agreements)
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure(_):
                completion(false)
            }
        }
    }
    
    private func saveUserToUserDefaults(user: User, token: String, agreements: [PlanAgreement]? = nil) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(user.username, forKey: "username")
        userDefaults.set(user.email, forKey: "email")
        userDefaults.set(user.id, forKey: "userID")
        userDefaults.set(token, forKey: "accessToken")

        if let agreements = agreements {
            let encoder = JSONEncoder()
            do {
                let encodedAgreements = try encoder.encode(agreements)
                userDefaults.set(encodedAgreements, forKey: "userPlanAgreements")
            } catch {
                print("Error al codificar los acuerdos: \(error.localizedDescription)")
            }
        }

        userDefaults.synchronize()
    }

    private func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
}
