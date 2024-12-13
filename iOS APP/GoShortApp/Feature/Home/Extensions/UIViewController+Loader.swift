//
//  UIViewController+Loader.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit

extension UIViewController {

    func showLoader() {

        if let existingLoader = self.view.viewWithTag(999) {
            existingLoader.removeFromSuperview()
        }
        
        let loaderView = UIView()
        loaderView.tag = 999
        loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        loaderView.layer.cornerRadius = 20
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        loaderView.addSubview(activityIndicator)
        self.view.addSubview(loaderView)
        
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loaderView.widthAnchor.constraint(equalToConstant: 100),
            loaderView.heightAnchor.constraint(equalToConstant: 100),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loaderView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loaderView.centerYAnchor)
        ])
    }
    
    func hideLoader() {
        if let loaderView = self.view.viewWithTag(999) {
            loaderView.removeFromSuperview()
        }
    }
}
