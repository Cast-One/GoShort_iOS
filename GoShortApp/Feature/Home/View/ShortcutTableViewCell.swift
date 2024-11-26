//
//  ShortcutTableViewCell.swift
//  GoShortApp
//
//  Created by Uriel C on 24/11/24.
//

import UIKit

/// Celda personalizada para mostrar información de un atajo (Shortcut).
/// Incluye etiquetas para índice, nombre, URL, y botones para copiar, compartir y abrir en el navegador.
class ShortcutTableViewCell: UITableViewCell {

    /// Etiqueta para mostrar el índice del atajo.
    let indexLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14) // Fuente en negritas para resaltar el índice.
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Etiqueta para mostrar el nombre del atajo.
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14) // Fuente en negritas para resaltar el nombre.
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Etiqueta para mostrar la URL corta del atajo.
    let urlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12) // Fuente más pequeña para la URL.
        label.textColor = .systemBlue // Color azul para indicar que es un enlace.
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Botón para copiar la URL corta al portapapeles.
    let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "clipboard"), for: .normal) // Icono de portapapeles.
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray // Color dinámico según el modo claro u oscuro.
        return button
    }()
    
    /// Botón para abrir la URL en el navegador (Safari).
    let webButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "network"), for: .normal) // Icono de red/navegador.
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBlue // Color azul para indicar funcionalidad de enlace.
        return button
    }()
    
    /// Botón para compartir la URL a través de las opciones nativas de iOS.
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal) // Icono de compartir.
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray // Color dinámico según el modo claro u oscuro.
        return button
    }()

    /// Inicializador de la celda con estilo predeterminado.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none // Deshabilita la selección visual de la celda.
        setupLayout() // Configura el diseño inicial.
    }

    /// Requerido pero no implementado, ya que no se utiliza storyboard.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Configura el diseño y las restricciones de Auto Layout de los elementos de la celda.
    private func setupLayout() {
        // Agrega las subviews al contentView.
        contentView.addSubview(indexLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(urlLabel)
        contentView.addSubview(copyButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(webButton)

        // Configuración de las restricciones de los elementos.
        NSLayoutConstraint.activate([
            indexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            indexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: indexLabel.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            urlLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            urlLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            urlLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            webButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            webButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            webButton.heightAnchor.constraint(equalToConstant: 20),
            webButton.widthAnchor.constraint(equalToConstant: 20),
            
            shareButton.trailingAnchor.constraint(equalTo: webButton.leadingAnchor, constant: -10),
            shareButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            shareButton.heightAnchor.constraint(equalToConstant: 25),
            shareButton.widthAnchor.constraint(equalToConstant: 20),
            
            copyButton.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -10),
            copyButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            copyButton.heightAnchor.constraint(equalToConstant: 25),
            copyButton.widthAnchor.constraint(equalToConstant: 20),
        ])
    }

    /// Configura los datos y las acciones de la celda.
    /// - Parameters:
    ///   - index: Índice del atajo en la lista.
    ///   - name: Nombre del atajo.
    ///   - url: URL corta del atajo.
    ///   - copyAction: Acción a ejecutar cuando se presiona el botón de copiar.
    ///   - webAction: Acción a ejecutar cuando se presiona el botón de abrir en navegador.
    ///   - shareAction: Acción a ejecutar cuando se presiona el botón de compartir.
    func configure(index: Int, name: String, url: String, copyAction: @escaping () -> Void, webAction: @escaping () -> Void, shareAction: @escaping () -> Void) {
        indexLabel.text = "\(index)" // Establece el índice del atajo.
        nameLabel.text = name // Establece el nombre del atajo.
        urlLabel.text = url // Establece la URL corta.

        // Configura las acciones para los botones.
        copyButton.addAction(UIAction(handler: { _ in copyAction() }), for: .touchUpInside)
        webButton.addAction(UIAction(handler: { _ in webAction() }), for: .touchUpInside)
        shareButton.addAction(UIAction(handler: { _ in shareAction() }), for: .touchUpInside)
    }
}
