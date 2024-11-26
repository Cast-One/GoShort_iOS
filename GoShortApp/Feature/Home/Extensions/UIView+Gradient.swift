//
//  UIView+Gradient.swift
//  GoShortApp
//
//  Created by Uriel C on 24/11/24.
//

import UIKit

/// Extensión de `UIView` para manejar colores de texto con efecto de gradiente.
extension UIView {

    /// Genera un color con gradiente que puede ser aplicado como color de texto.
    ///
    /// Esta función crea un `UIColor` con un patrón de imagen basado en un gradiente.
    /// Es útil para aplicar un efecto de gradiente en textos.
    ///
    /// - Parameters:
    ///   - colors: Un arreglo de colores (`UIColor`) que conformarán el gradiente.
    ///   - text: El texto al que se aplicará el color de gradiente.
    ///   - font: La fuente del texto, utilizada para calcular el tamaño del gradiente.
    /// - Returns: Un `UIColor` con el gradiente aplicado como patrón de imagen, o `nil` si ocurre un error.
    func gradientTextColor(colors: [UIColor], text: String, font: UIFont) -> UIColor? {
        // Crear una capa de gradiente (CAGradientLayer).
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor } // Colores del gradiente.
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5) // Punto de inicio (izquierda).
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5) // Punto de fin (derecha).
        
        // Determinar el tamaño necesario para el texto con la fuente dada.
        let textSize = (text as NSString).size(withAttributes: [.font: font])
        gradientLayer.frame = CGRect(origin: .zero, size: textSize) // Tamaño del gradiente.

        // Crear un contexto gráfico para renderizar la capa de gradiente.
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, 0)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!) // Renderizar el gradiente.
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext() // Obtener la imagen resultante.
        UIGraphicsEndImageContext() // Cerrar el contexto gráfico.
        
        // Verificar si la imagen del gradiente fue generada correctamente.
        if let gradientImage = gradientImage {
            // Retornar un `UIColor` con un patrón de imagen basado en el gradiente.
            return UIColor(patternImage: gradientImage)
        }
        
        // Retornar `nil` en caso de error.
        return nil
    }
}
