//
//  ShortcutsViewController+UITextFieldDelegate.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit

extension ShortcutsViewController: UITextFieldDelegate {
    /// Configura el comportamiento del botón de retorno en el teclado.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Ocultar el teclado
        handleShortenAction() // Realizar la acción de acortar
        return true
    }
    
    /// Acción que se ejecuta cuando se presiona el botón de acortar o el retorno en el teclado.
    @objc func handleShortenAction() {
        guard let user = UserManager.shared.getUser() else { return }
        
        urlTextField.endEditing(true)

        if !user.isPremium && ShortcutManager.shared.getShortcutsCount() >= 20 {
            // Mostrar alerta de límite alcanzado
            showPremiumLimitAlert()
            return
        }
    
        guard let urlString = urlTextField.text, !urlString.isEmpty else {
            showToast(message: LocalizableConstants.Toast.enterURL)
            return
        }
        
        if isValidURL(urlString) {
            // Mostrar el loader
            showLoader()
            
            // Simular proceso de acortamiento de URL con un retraso de 3 segundos.
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.hideLoader() // Ocultar loader
                
                // Simulación de URL acortada
                let shortenedURL = "https://short.url/\(UUID().uuidString.prefix(6))"
                self?.showToast(message: "\(LocalizableConstants.Toast.urlShortened) \(shortenedURL)")
                self?.urlTextField.text = "" // Limpiar el campo de texto
                
                // Crear un nuevo objeto de tipo URLItem
                let newItem = URLItem(
                    title: "New URL \(urlList.count + 1)", // Asignar un título genérico
                    shortURL: shortenedURL,
                    longURL: urlString,
                    creationDate: self?.getCurrentDate() ?? "" // Obtener la fecha actual
                )
                
                // Agregar el nuevo objeto a la lista
                urlList.append(newItem)
                self?.currentShortcuts = urlList // Actualizar la lista actual mostrada en la tabla
                        
                // Incrementar el número de URLs creadas
                UserManager.shared.incrementURLsCreated()
            }
        } else {
            showToast(message: LocalizableConstants.Toast.invalidURL)
        }
    }
    
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    /// Muestra una alerta si el usuario alcanza el límite de URLs.
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

    /// Navega a la vista de promoción premium.
    private func navigateToPremiumView() {
        let premiumViewController = PremiumViewController()
        premiumViewController.delegate = self
        navigationController?.present(premiumViewController, animated: true)
    }

    /// Valida si el texto proporcionado es una URL válida.
    /// - Parameter urlString: El texto a validar.
    /// - Returns: `true` si es una URL válida; de lo contrario, `false`.
    private func isValidURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
}
