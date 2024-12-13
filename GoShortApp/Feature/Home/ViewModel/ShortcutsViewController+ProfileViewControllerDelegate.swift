//
//  ShortcutsViewController+ProfileViewControllerDelegate.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit

extension ShortcutsViewController: ProfileViewControllerDelegate {
    func didTapAcquirePremium() {
        DispatchQueue.main.async {
            self.presentPremiumViewController()
        }
    }
}
