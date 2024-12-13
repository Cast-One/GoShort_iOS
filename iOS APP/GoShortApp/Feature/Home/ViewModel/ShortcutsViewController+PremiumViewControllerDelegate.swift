//
//  ShortcutsViewController+PremiumViewControllerDelegate.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit

extension ShortcutsViewController: PremiumViewControllerDelegate {
    
    func presentPremiumViewController() {
        self.showLoader()

        fetchPremiumPlanID { [weak self] planID in
            DispatchQueue.main.async {
                self?.hideLoader()
                guard let planID = planID else {
                    return
                }
                let premiumVC = PremiumViewController(premiumPlanID: planID)
                premiumVC.delegate = self
                self?.navigationController?.present(premiumVC, animated: true)
            }
        }
    }
    
    func didBecomePremium(controller: PremiumViewController) {
        self.isPremiumUser = UserDefaultsManager.shared.isPremiumUser()
        
        controller.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.showLoader()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.hideLoader()
                let newShortcutsVC = ShortcutsViewController()
                UIView.transition(with: self.view.window!,
                                  duration: 0.8,
                                  options: .transitionFlipFromRight,
                                  animations: {
                                      let navigationController = UINavigationController(rootViewController: newShortcutsVC)
                                      UIApplication.shared.windows.first?.rootViewController = navigationController
                                      UIApplication.shared.windows.first?.makeKeyAndVisible()
                                  },
                                  completion: nil)
            }
        }
    }
}
