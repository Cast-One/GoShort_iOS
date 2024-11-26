//
//  ShortcutsViewController.swift
//  GoShortApp
//
//  Created by Uriel C on 24/11/24.
//

import UIKit

/// Controlador que gestiona la pantalla de atajos (Shortcuts).
/// Permite al usuario crear, visualizar y personalizar URLs. Ofrece funcionalidades adicionales si el usuario es premium.
class ShortcutsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var user: User?
    /// Indica si el usuario es premium. Los usuarios premium tienen acceso a más funcionalidades.
    var isPremiumUser = false
    
    /// Etiqueta de título principal. Muestra el estado (Free o Premium) y el nombre de la app.
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Texto del título basado en el estado del usuario (Free o Premium).
        var fullText = "\(LocalizableConstants.Labels.titleLabelFree) \(LocalizableConstants.General.nameApp)"
        if let user = UserManager.shared.getUser() {
            fullText = "\(user.isPremium ? LocalizableConstants.Labels.titleLabelPreimum : LocalizableConstants.Labels.titleLabelFree) \(LocalizableConstants.General.nameApp)"
        }
        
        // Fuente y atributos
        let boldFont = UIFont.boldSystemFont(ofSize: 18)
        let regularFont = UIFont.boldSystemFont(ofSize: 24)
        
        // Crear texto estilizado
        let attributedText = NSMutableAttributedString(string: fullText)
        
        // Aplicar negrita a "Free" o "Premium"
        if let user = UserManager.shared.getUser() {
            let range = (fullText as NSString).range(of: user.isPremium ? LocalizableConstants.Labels.titleLabelPreimum : LocalizableConstants.Labels.titleLabelFree)
            attributedText.addAttributes([
                .font: boldFont,
                .foregroundColor: UIColor.label
            ], range: range)
        } else {
            let range = (fullText as NSString).range(of: LocalizableConstants.Labels.titleLabelFree)
            attributedText.addAttributes([
                .font: boldFont,
                .foregroundColor: UIColor.black
            ], range: range)
        }
        
        // Aplicar gradiente al nombre de la app
        let appNameRange = (fullText as NSString).range(of: LocalizableConstants.General.nameApp)
        if let gradientColor = label.gradientTextColor(colors: [.systemBlue, .systemPurple], text: LocalizableConstants.General.nameApp, font: regularFont) {
            attributedText.addAttributes([
                .font: regularFont,
                .foregroundColor: gradientColor
            ], range: appNameRange)
        }
        
        label.attributedText = attributedText
        return label
    }()
    
    /// Etiqueta que actúa como encabezado para el campo de texto de URL.
    let headerUrlTextField: UILabel = {
        let label = UILabel()
        label.text = LocalizableConstants.Labels.urlHeaderText
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Campo de texto para que el usuario ingrese una URL.
    let urlTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizableConstants.Labels.urlPlaceholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = .URL
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    /// Botón para acortar una URL ingresada.
    let shortenButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBackground
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitle(LocalizableConstants.Buttons.shortenButtonTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        // Configuración de sombra y bordes redondeados.
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = false

        return button
    }()

    /// Botón para crear un atajo personalizado (solo disponible para usuarios premium).
    let customButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizableConstants.Buttons.customButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false

        // Configuración de sombra, bordes redondeados y fondo.
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true

        return button
    }()

    /// Vista en forma de stack horizontal que contiene los botones `shortenButton` y `customButton`.
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    /// Control segmentado que permite alternar entre atajos regulares y personalizados.
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [LocalizableConstants.SegmentedControl.shortcuts, LocalizableConstants.SegmentedControl.customShortcuts])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    /// Tabla para mostrar la lista de atajos actuales.
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ShortcutCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    /// Etiqueta que se muestra cuando la lista de atajos está vacía.
    let emptyPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableConstants.Placeholders.emptyListMessage
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .gray.withAlphaComponent(0.5)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    /// Botón para invitar al usuario a convertirse en premium.
    let premiumButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizableConstants.Buttons.premiumButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false

        // Configuración de sombra, bordes redondeados y fondo.
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        return button
    }()
    
    /// Botón de perfil con un ícono circular
    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        // Configuración de la imagen del botón
        button.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        button.tintColor = .label // Cambiar color del ícono si es necesario
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()

    /// Lista actual de atajos. Cada vez que se actualiza, se recarga la tabla y se evalúa si mostrar el placeholder.
    var currentShortcuts: [URLItem] = [] {
        didSet {
            self.tableView.reloadData()
            self.updatePlaceholderVisibility()
        }
    }

    // MARK: - Ciclo de Vida
    /// Configuración inicial de la vista.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.isHidden = true
        
        if let user = UserManager.shared.getUser() {
            self.user = user
            self.isPremiumUser = self.user?.isPremium ?? false
        } else {
            self.isPremiumUser = false
        }
        
        currentShortcuts = urlList
        self.updatePlaceholderVisibility()
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ShortcutTableViewCell.self, forCellReuseIdentifier: "ShortcutCell")
        
        buttonStackView.addArrangedSubview(shortenButton)
        buttonStackView.addArrangedSubview(customButton)
        urlTextField.delegate = self

        view.addSubview(titleLabel)
        view.addSubview(headerUrlTextField)
        view.addSubview(urlTextField)
        view.addSubview(buttonStackView)
        view.addSubview(profileButton)

        if isPremiumUser {
            view.addSubview(segmentedControl)
        }

        view.addSubview(tableView)
        view.addSubview(emptyPlaceholderLabel)

        if !isPremiumUser {
            view.addSubview(premiumButton)
        }

        setupLayout()
    }

    /// Ajusta el tamaño de los gradientes en los botones personalizados.
    /// Configura o actualiza el gradiente de fondo en un botón.
    /// - Parameters:
    ///   - button: El botón al que se aplicará el gradiente.
    ///   - colors: Los colores del gradiente.
    ///   - startPoint: El punto inicial del gradiente (por defecto, horizontal desde la izquierda).
    ///   - endPoint: El punto final del gradiente (por defecto, horizontal hacia la derecha).
    func applyGradient(to button: UIButton, colors: [CGColor], startPoint: CGPoint = CGPoint(x: 0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1, y: 0.5)) {
        // Buscar un gradiente existente en las capas del botón.
        if let gradientLayer = button.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientLayer.frame = button.bounds // Actualizar tamaño del gradiente.
        } else {
            // Crear un nuevo gradiente si no existe.
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = colors
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
            gradientLayer.cornerRadius = button.layer.cornerRadius
            gradientLayer.frame = button.bounds
            button.layer.insertSublayer(gradientLayer, at: 0)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Aplicar gradiente a los botones relevantes.
        applyGradient(to: customButton, colors: [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor])
        applyGradient(to: premiumButton, colors: [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor])
    }

    // MARK: - Configuración de Diseño
    /// Configura las restricciones de Auto Layout para los elementos de la vista.
    func setupLayout() {
        
        shortenButton.addTarget(self, action: #selector(handleShortenAction), for: .touchUpInside)
        premiumButton.addTarget(self, action: #selector(premiumClicked), for: .touchUpInside)
        customButton.addTarget(self, action: #selector(customUrlClicked), for: .touchUpInside)

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            profileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            headerUrlTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            headerUrlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            urlTextField.topAnchor.constraint(equalTo: headerUrlTextField.bottomAnchor, constant: 5),
            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            buttonStackView.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 40)
            
        ])

        if isPremiumUser {
            customButton.isHidden = false
            shortenButton.isHidden = false
            NSLayoutConstraint.activate([
                segmentedControl.topAnchor.constraint(equalTo: customButton.bottomAnchor, constant: 30),
                segmentedControl.heightAnchor.constraint(equalToConstant: 40),
                segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
        } else {
            customButton.isHidden = true
            shortenButton.isHidden = false
        }

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: isPremiumUser ? segmentedControl.bottomAnchor : shortenButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: isPremiumUser ? view.safeAreaLayoutGuide.bottomAnchor : premiumButton.topAnchor, constant:  isPremiumUser ? 0 : -20),
            
            emptyPlaceholderLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyPlaceholderLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            emptyPlaceholderLabel.widthAnchor.constraint(equalTo: tableView.widthAnchor, multiplier: 0.8)
        ])

        if !isPremiumUser {
            NSLayoutConstraint.activate([
                premiumButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                premiumButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                premiumButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                premiumButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    /// Muestra u oculta el mensaje de placeholder dependiendo de si hay atajos en la lista.
    func updatePlaceholderVisibility() {
        emptyPlaceholderLabel.isHidden = !currentShortcuts.isEmpty
    }

    // MARK: - Acciones
    /// Cambia entre listas de atajos normales y personalizados según el segmento seleccionado.
    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentShortcuts = urlList
        } else {
            currentShortcuts = urlCustomList
        }
    }

    @objc func premiumClicked() {
        let controller = PremiumViewController()
        controller.delegate = self
        self.navigationController?.present(controller, animated: true)
    }
    
    @objc func customUrlClicked() {
        let controller = CustomURLViewController(url: self.urlTextField.text ?? "")
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /// Acción que se ejecuta al tocar el botón de perfil
    @objc private func profileButtonTapped() {
        let controller = ProfileViewController()
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

