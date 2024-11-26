//
//  ShortcutsViewController+CustomURLViewControllerDelegate.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

extension ShortcutsViewController: CustomURLViewControllerDelegate {
    func didGenerateCustomURL(controller: CustomURLViewController) {
        controller.navigationController?.popViewController(animated: true)
        
        self.tableView.reloadData()
        self.updatePlaceholderVisibility()
        
        showToast(message: "URL personalizada generada")
    }
}
