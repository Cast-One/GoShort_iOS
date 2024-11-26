//
//  CustomURLViewController.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit

protocol CustomURLViewControllerDelegate: AnyObject {
    /// Notifica que se ha generado una nueva URL personalizada.
    func didGenerateCustomURL(controller: CustomURLViewController)
}

/// Controlador para generar URLs personalizadas con opciones avanzadas como selección de dominio y sufijo.
class CustomURLViewController: UIViewController, UITextFieldDelegate {

    // MARK: - UI Elements
    
    weak var delegate: CustomURLViewControllerDelegate?

    /// Botón para regresar a la vista anterior.
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .label
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    /// Título principal con gradiente.
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableConstants.Labels.titleCustomURL
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Etiqueta para el campo de texto de URL larga.
    let headerLargeURLTextField: UILabel = {
        let label = UILabel()
        label.text = LocalizableConstants.Labels.headerLargeURL
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Campo de texto para ingresar una URL larga.
    let largeURLTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizableConstants.Placeholders.largeURL
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .URL
        return textField
    }()

    /// Etiqueta para el campo de texto de nombre personalizado.
    let headerCustomNameTextField: UILabel = {
        let label = UILabel()
        label.text = LocalizableConstants.Labels.headerCustomName
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Campo de texto para ingresar un nombre personalizado.
    let customNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizableConstants.Placeholders.customName
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    /// Etiqueta para el selector de dominio.
    let headerDomainStackView: UILabel = {
        let label = UILabel()
        label.text = LocalizableConstants.Labels.headerDomainSelected
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Contenedor para el selector de dominio y el sufijo.
    let domainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    /// Campo de texto para seleccionar el dominio.
    let domainPicker: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = LocalizableConstants.Placeholders.domainPicker
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = .never
        return textField
    }()

    /// Campo de texto para ingresar un sufijo del dominio.
    let domainSuffixTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizableConstants.Placeholders.domainSuffix
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    /// Botón para generar la URL personalizada.
    let generateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizableConstants.Buttons.generateButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()

    private var initialURL: String?

    /// Inicializador personalizado que recibe una URL larga opcional.
    /// - Parameter url: URL larga opcional para inicializar el campo de texto.
    init(url: String? = nil) {
        self.initialURL = url
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// MARK: - View Lifecycle
    
    let domainPickerView = UIPickerView()
    let availableDomains = ["https://go.short/", "https://my.link/"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
        setupGradientForTitle()
        setupActions()
        
        setupDomainPicker()
        domainPicker.inputView = domainPickerView // Asignar el UIPickerView como inputView

        // Poblar el campo de texto con la URL inicial si está disponible
        if let url = initialURL {
            largeURLTextField.text = url
        }
    }
    
    
    private func setupDomainPicker() {
        domainPickerView.delegate = self
        domainPickerView.dataSource = self
        domainPicker.inputView = domainPickerView // Configurar el Picker como teclado para domainPicker
        domainPicker.addTarget(self, action: #selector(showDomainPicker), for: .touchDown) // Mostrar el PickerView
    }

    @objc private func showDomainPicker() {
        domainPicker.becomeFirstResponder() // Hacer que el campo sea el primer responder
    }

    @objc private func backButtonTapped() {
        // Hace un pop de la vista actual
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Aplicar gradiente a los botones relevantes.
        applyGradient(to: generateButton, colors: [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor])
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
    
    // MARK: - Setup
    
    /// Agrega subviews a la vista principal
    private func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(headerLargeURLTextField)
        view.addSubview(largeURLTextField)
        view.addSubview(headerCustomNameTextField)
        view.addSubview(customNameTextField)
        view.addSubview(headerDomainStackView)
        view.addSubview(domainStackView)
        view.addSubview(generateButton)
        view.addSubview(backButton)
        
        domainStackView.addArrangedSubview(domainPicker)
        domainStackView.addArrangedSubview(domainSuffixTextField)
        
        largeURLTextField.delegate = self
        customNameTextField.delegate = self
        domainSuffixTextField.delegate = self
    }

    /// Configura las constraints para los elementos de la vista
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Título
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            // Large URL TextField
            headerLargeURLTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            headerLargeURLTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerLargeURLTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            largeURLTextField.topAnchor.constraint(equalTo: headerLargeURLTextField.bottomAnchor, constant: 10),
            largeURLTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            largeURLTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Custom Name TextField
            headerCustomNameTextField.topAnchor.constraint(equalTo: largeURLTextField.bottomAnchor, constant: 20),
            headerCustomNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerCustomNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            customNameTextField.topAnchor.constraint(equalTo: headerCustomNameTextField.bottomAnchor, constant: 10),
            customNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Domain Stack View
            headerDomainStackView.topAnchor.constraint(equalTo: customNameTextField.bottomAnchor, constant: 20),
            headerDomainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerDomainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            domainStackView.topAnchor.constraint(equalTo: headerDomainStackView.bottomAnchor, constant: 10),
            domainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            domainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            domainPicker.widthAnchor.constraint(equalTo: domainStackView.widthAnchor, multiplier: 0.5),
            domainSuffixTextField.widthAnchor.constraint(equalTo: domainStackView.widthAnchor, multiplier: 0.5),
            
            // Generate Button
            generateButton.topAnchor.constraint(equalTo: domainStackView.bottomAnchor, constant: 30),
            generateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            generateButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    /// Configura un gradiente para el título
    private func setupGradientForTitle() {
        if let gradientColor = titleLabel.gradientTextColor(colors: [.systemBlue, .systemPurple], text: "Custom URL", font: UIFont.boldSystemFont(ofSize: 30)) {
            titleLabel.textColor = gradientColor
        }
    }
    
    /// Configura acciones para el botón
    private func setupActions() {
        generateButton.addTarget(self, action: #selector(handleGenerateButton), for: .touchUpInside)
    }

    private func validateAllFields() -> Bool {
            if largeURLTextField.text?.isEmpty == true || !isValidURL(largeURLTextField.text!) {
                showToast(message: "La URL ingresada no es válida.")
                return false
            }
            if customNameTextField.text?.isEmpty == true {
                showToast(message: "El campo 'Custom Name' no puede estar vacío.")
                return false
            }
            if domainSuffixTextField.text?.isEmpty == true || !isValidPath(domainSuffixTextField.text!) {
                showToast(message: "El campo 'Domain Suffix' no es válido.")
                return false
            }
            return true
        }

    private func isValidURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    private func isValidPath(_ path: String) -> Bool {
        let pathRegex = "^[a-zA-Z0-9_-]+$"
        return NSPredicate(format: "SELF MATCHES %@", pathRegex).evaluate(with: path)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Actions
    
    /// Acción para generar la URL personalizada
    @objc private func handleGenerateButton() {
        guard validateAllFields() else { return }
        
        // Obtener los valores de los campos de texto
       guard let longURL = largeURLTextField.text,
             let customName = customNameTextField.text,
             let domain = domainPicker.text,
             let suffix = domainSuffixTextField.text else { return }

       // Generar la URL personalizada
       let shortenedURL = "\(domain)\(suffix)"
       let currentDate = getCurrentDate() // Usar la función para obtener la fecha actual

       // Crear un nuevo URLItem
       let newURLItem = URLItem(
           title: customName,
           shortURL: shortenedURL,
           longURL: longURL,
           creationDate: currentDate
       )

       // Agregar el nuevo URLItem a la lista urlCustomList
       urlCustomList.append(newURLItem)

       // Limpiar los campos de texto después de generar la URL
       largeURLTextField.text = ""
       customNameTextField.text = ""
       domainSuffixTextField.text = ""
        
        self.delegate?.didGenerateCustomURL(controller: self)
    }
    
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

