//
//  UIViewController+Toast.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit

extension UIViewController {
    
    func showToast(message: String, duration: TimeInterval = 2.0) {
        class PaddedLabel: UILabel {
            var padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)

            override func drawText(in rect: CGRect) {
                let insetRect = rect.inset(by: padding)
                super.drawText(in: insetRect)
            }

            override var intrinsicContentSize: CGSize {
                let size = super.intrinsicContentSize
                return CGSize(width: size.width + padding.left + padding.right,
                              height: size.height + padding.top + padding.bottom)
            }
        }

        let toastLabel = PaddedLabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(toastLabel)

        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            toastLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            toastLabel.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 0.8),
        ])

        UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
