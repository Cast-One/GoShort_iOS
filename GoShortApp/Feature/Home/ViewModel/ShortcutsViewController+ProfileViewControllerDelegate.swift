//
//  ShortcutsViewController+ProfileViewControllerDelegate.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

extension ShortcutsViewController: ProfileViewControllerDelegate {
    func didTapAcquirePremium() {
        let controller = PremiumViewController()
        controller.delegate = self
        self.navigationController?.present(controller, animated: true)
    }
}
