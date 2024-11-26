//
//  ShortcutsViewController+PremiumViewControllerDelegate.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit

extension ShortcutsViewController: PremiumViewControllerDelegate {
    func didBecomePremium(controller: PremiumViewController) {
        // Actualiza el estado del usuario a premium
        self.isPremiumUser = true
        
        // Desvanece el controlador premium
        controller.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            // Muestra el loader
            self.showLoader()
            
            // Simula un proceso con un retraso de 3 segundos
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                // Oculta el loader
                self.hideLoader()
                
                // Configura el nuevo controlador
                let newShortcutsVC = ShortcutsViewController()
                
                // Realiza la animación de giro y establece la nueva raíz
                UIView.transition(with: self.view.window!,
                                  duration: 0.8,
                                  options: .transitionFlipFromRight,
                                  animations: {
                                      // Reemplaza la pila de navegación con el nuevo controlador como raíz
                                      let navigationController = UINavigationController(rootViewController: newShortcutsVC)
                                      UIApplication.shared.windows.first?.rootViewController = navigationController
                                      UIApplication.shared.windows.first?.makeKeyAndVisible()
                                  },
                                  completion: nil)
            }
        }
    }
}
