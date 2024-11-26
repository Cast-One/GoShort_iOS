//
//  UIViewController+Loader.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit

extension UIViewController {
    /// Muestra un loader con fondo negro y padding.
    func showLoader() {
        // Verificar si ya existe un loader en la vista.
        if let existingLoader = self.view.viewWithTag(999) {
            existingLoader.removeFromSuperview()
        }
        
        // Crear la vista negra con padding.
        let loaderView = UIView()
        loaderView.tag = 999 // Identificador único para encontrarlo fácilmente
        loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        loaderView.layer.cornerRadius = 20
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        
        // Agregar un indicador de actividad al centro.
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        // Agregar elementos a la jerarquía de vistas.
        loaderView.addSubview(activityIndicator)
        self.view.addSubview(loaderView)
        
        // Configurar restricciones para centrar el loader y establecer padding.
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loaderView.widthAnchor.constraint(equalToConstant: 100),
            loaderView.heightAnchor.constraint(equalToConstant: 100),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loaderView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loaderView.centerYAnchor)
        ])
    }
    
    /// Oculta el loader si está presente en la vista.
    func hideLoader() {
        if let loaderView = self.view.viewWithTag(999) {
            loaderView.removeFromSuperview()
        }
    }
}
