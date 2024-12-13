//
//  UIView+Gradient.swift
//  GoShortApp
//
//  Created by Uriel C on 24/11/24.
//

import UIKit

extension UIView {
    
    func gradientTextColor(colors: [UIColor], text: String, font: UIFont) -> UIColor? {

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let textSize = (text as NSString).size(withAttributes: [.font: font])
        gradientLayer.frame = CGRect(origin: .zero, size: textSize)

        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, 0)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let gradientImage = gradientImage {
            return UIColor(patternImage: gradientImage)
        }
        
        return nil
    }
}
