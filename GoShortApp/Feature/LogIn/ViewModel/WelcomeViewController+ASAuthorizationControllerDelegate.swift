//
//  WelcomeViewController+ASAuthorizationControllerDelegate.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit
import AuthenticationServices

// MARK: - ASAuthorizationControllerDelegate

extension WelcomeViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let fullName = appleIDCredential.fullName

            // Generar un UUID corto si el nombre es nulo
            let name = fullName?.givenName ?? String(UUID().uuidString.prefix(16))
            ShortcutManager.shared.resetShortcutsCount()
            ShortcutManager.shared.incrementShortcutsCountBy(times: 19)
            let user = User(name: name, phone: "", isPremium: false, urlsCreated: 19)

            // Guardar el usuario en el UserManager
            UserManager.shared.saveUser(user: user)

            // Navegar al ShortcutsViewController
            self.navigationController?.viewControllers = [ShortcutsViewController()]
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        showToast(message: "\(LocalizableConstants.Welcome.appleLoginError)\(error.localizedDescription)")
    }
}


// MARK: - ASAuthorizationControllerPresentationContextProviding

extension WelcomeViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
