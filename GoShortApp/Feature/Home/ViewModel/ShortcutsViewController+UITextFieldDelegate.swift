//
//  ShortcutsViewController+UITextFieldDelegate.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit

extension ShortcutsViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        handleShortenAction()
        return true
    }
    
    @objc func handleShortenAction() {
        guard let urlString = urlTextField.text, !urlString.isEmpty else {
            showToast(message: LocalizableConstants.Toast.enterURL)
            return
        }

        guard isValidURL(urlString) else {
            showToast(message: LocalizableConstants.Toast.invalidURL)
            return
        }

        urlTextField.endEditing(true)
        
        if !self.isPremiumUser && self.getTotalURLsCount() >= 5 {
            // Mostrar alerta de límite alcanzado
            showPremiumLimitAlert()
            return
        }
    
        showLoader()

        let shortenEndpoint = APIManager.Endpoint(
            path: "/shorten",
            method: .POST,
            parameters: ["url": urlString],
            headers: [
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")",
                "Content-Type": "application/json"
            ]
        )

        APIManager.shared.request(endpoint: shortenEndpoint, responseType: ShortenURLResponse.self) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.hideLoader()
            }

            switch result {
            case .success(let response):
                if response.success {
                    DispatchQueue.main.async {
                        self.showToast(message: "\(LocalizableConstants.Toast.urlShortened) \(response.data.shortened_url)")
                        self.urlTextField.text = ""

                        self.fetchURLsFromAPI()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showToast(message: "Error: \(response.message)")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showToast(message: "Error al acortar la URL: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showPremiumLimitAlert() {
        let alertController = UIAlertController(
            title: LocalizableConstants.PremiumLimit.alertTitle,
            message: LocalizableConstants.PremiumLimit.alertMessage,
            preferredStyle: .alert
        )
        
        let becomePremiumAction = UIAlertAction(
            title: LocalizableConstants.PremiumLimit.becomePremium,
            style: .default
        ) { [weak self] _ in
            self?.navigateToPremiumView()
        }
        
        let cancelAction = UIAlertAction(
            title: LocalizableConstants.PremiumLimit.cancel,
            style: .cancel,
            handler: nil
        )
        
        alertController.addAction(becomePremiumAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    private func navigateToPremiumView() {
        presentPremiumViewController()
    }

    private func isValidURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
}
