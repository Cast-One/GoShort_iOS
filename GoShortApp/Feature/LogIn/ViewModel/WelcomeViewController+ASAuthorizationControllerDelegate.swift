//
//  WelcomeViewController+ASAuthorizationControllerDelegate.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit
import AuthenticationServices
 

extension WelcomeViewController {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userID = appleIDCredential.user
            var email = appleIDCredential.email
            
            if email == nil, let identityTokenData = appleIDCredential.identityToken {
                email = decodeJWTForEmail(token: identityTokenData) ?? generateFakeEmail(for: userID)
            }

            let username = userID
            let password = "12345678"
            
            registerOrLogin(username: username, email: email ?? "", password: password)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        showToast(message: "\(LocalizableConstants.Welcome.appleLoginError)\(error.localizedDescription)")
    }
}

extension WelcomeViewController {
    private func decodeJWTForEmail(token: Data) -> String? {
        guard let jwt = String(data: token, encoding: .utf8) else { return nil }
        let segments = jwt.split(separator: ".")
        guard segments.count == 3 else { return nil } // Un JWT tiene 3 partes: header, payload, signature
        
        let payloadSegment = segments[1]
        let paddedSegment = payloadSegment.padding(toLength: ((payloadSegment.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
        guard let payloadData = Data(base64Encoded: paddedSegment),
              let payloadJSON = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] else {
            return nil
        }
        
        return payloadJSON["email"] as? String
    }
    
    private func generateFakeEmail(for userID: String) -> String {
        return "user_\(userID)@goshrtapp.com"
    }
}

extension WelcomeViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
