//
//  ProfileViewController.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit

/// Protocolo para manejar acciones desde el `ProfileViewController`.
protocol ProfileViewControllerDelegate: AnyObject {
    /// Notifica al delegado cuando el usuario desea adquirir el plan Premium.
    func didTapAcquirePremium()
}

/// Controlador que gestiona la pantalla del perfil del usuario.
/// Muestra el nombre, estado de cuenta, cantidad de URLs generadas, y permite adquirir Premium o cerrar sesión.
class ProfileViewController: UIViewController {

    // MARK: - Delegado
    weak var delegate: ProfileViewControllerDelegate?

    // MARK: - UI Elements

    /// Botón para regresar a la pantalla anterior.
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .label
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    /// Etiqueta que muestra el nombre del usuario.
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Etiqueta que muestra el nombre de usuario con formato decorativo.
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Vista contenedora para mostrar la cantidad de URLs generadas.
    let urlsGeneratedView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Etiqueta que muestra el texto "URLs generadas".
    let urlsGeneratedLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableConstants.Profile.urls_generated
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Etiqueta que muestra la cantidad de URLs generadas.
    let urlsGeneratedCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Botón para adquirir el plan Premium.
    let premiumButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizableConstants.Profile.acquire_premium, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(acquirePremiumTapped), for: .touchUpInside)
        return button
    }()

    /// Etiqueta que muestra el estado Premium del usuario.
    let premiumStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Botón para cerrar sesión y regresar a la pantalla de bienvenida.
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizableConstants.Profile.logout, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - View Lifecycle

    /// Configuración inicial del controlador.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
        loadUserData()
    }

    /// Configura los subviews en la vista principal.
    private func setupSubviews() {
        view.addSubview(nameLabel)
        view.addSubview(backButton)
        view.addSubview(usernameLabel)
        view.addSubview(urlsGeneratedView)
        urlsGeneratedView.addSubview(urlsGeneratedLabel)
        urlsGeneratedView.addSubview(urlsGeneratedCountLabel)
        view.addSubview(premiumButton)
        view.addSubview(premiumStatusLabel)
        view.addSubview(logoutButton)
    }

    /// Aplica gradientes y actualiza etiquetas después de configurar el layout.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Aplicar gradiente al botón Premium.
        applyGradient(to: premiumButton, colors: [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor])

        // Aplicar gradiente al texto del estado Premium.
        let user = UserManager.shared.getUser()
        let statusText = user?.isPremium == true
            ? LocalizableConstants.Profile.premium_status_yes
            : LocalizableConstants.Profile.premium_status_no
        applyGradientToLabel(
            label: premiumStatusLabel,
            text: statusText,
            colors: [.systemBlue, .systemPurple],
            font: UIFont.systemFont(ofSize: 14)
        )
    }

    // MARK: - Métodos Auxiliares

    /// Aplica un gradiente a un UIButton.
    func applyGradient(to button: UIButton, colors: [CGColor], startPoint: CGPoint = CGPoint(x: 0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1, y: 0.5)) {
        if let gradientLayer = button.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientLayer.frame = button.bounds
        } else {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = colors
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
            gradientLayer.cornerRadius = button.layer.cornerRadius
            gradientLayer.frame = button.bounds
            button.layer.insertSublayer(gradientLayer, at: 0)
        }
    }

    /// Aplica un gradiente a todo el texto de un UILabel.
    func applyGradientToLabel(label: UILabel, text: String, colors: [UIColor], font: UIFont) {
        // Establecer texto y fuente primero para calcular correctamente el tamaño.
        label.text = text
        label.font = font
        label.sizeToFit() // Ajustar tamaño de la etiqueta antes de crear el gradiente.

        guard label.bounds.size != .zero else { return } // Evitar contextos con tamaño inválido.

        // Crear un renderer gráfico basado en el tamaño de la etiqueta.
        let renderer = UIGraphicsImageRenderer(size: label.bounds.size)
        let gradientImage = renderer.image { context in
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = colors.map { $0.cgColor }
            gradientLayer.frame = CGRect(origin: .zero, size: label.bounds.size)
            gradientLayer.render(in: context.cgContext)
        }

        // Crear un atributo estilizado con el gradiente como color del texto.
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(patternImage: gradientImage),
            .font: font
        ]
        label.attributedText = NSAttributedString(string: text, attributes: textAttributes)
    }

    /// Configura las restricciones de Auto Layout.
    private func setupConstraints() {
        guard let user = UserManager.shared.getUser() else { return }
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),

            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            urlsGeneratedView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 30),
            urlsGeneratedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            urlsGeneratedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            urlsGeneratedView.heightAnchor.constraint(equalToConstant: 50),

            urlsGeneratedLabel.leadingAnchor.constraint(equalTo: urlsGeneratedView.leadingAnchor, constant: 15),
            urlsGeneratedLabel.centerYAnchor.constraint(equalTo: urlsGeneratedView.centerYAnchor),

            urlsGeneratedCountLabel.trailingAnchor.constraint(equalTo: urlsGeneratedView.trailingAnchor, constant: -15),
            urlsGeneratedCountLabel.centerYAnchor.constraint(equalTo: urlsGeneratedView.centerYAnchor),
        ])

        if user.isPremium {
            premiumButton.isHidden = true
            premiumStatusLabel.isHidden = false

            NSLayoutConstraint.activate([
                premiumStatusLabel.topAnchor.constraint(equalTo: urlsGeneratedView.bottomAnchor, constant: 10),
                premiumStatusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                logoutButton.topAnchor.constraint(equalTo: premiumStatusLabel.bottomAnchor, constant: 30),
                logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                logoutButton.heightAnchor.constraint(equalToConstant: 50),
            ])

        } else {
            premiumStatusLabel.isHidden = true
            premiumButton.isHidden = false

            NSLayoutConstraint.activate([
                premiumButton.topAnchor.constraint(equalTo: urlsGeneratedView.bottomAnchor, constant: 30),
                premiumButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                premiumButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                premiumButton.heightAnchor.constraint(equalToConstant: 50),

                logoutButton.topAnchor.constraint(equalTo: premiumButton.bottomAnchor, constant: 10),
                logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                logoutButton.heightAnchor.constraint(equalToConstant: 50),
            ])
        }
    }

    /// Carga los datos del usuario y actualiza las etiquetas.
    private func loadUserData() {
        guard let user = UserManager.shared.getUser() else { return }
        nameLabel.text = user.name
        usernameLabel.text = "@\(user.name)"
        urlsGeneratedCountLabel.text = "\(user.urlsCreated)"
    }

    // MARK: - Actions

    /// Navega al delegado para gestionar la adquisición del plan Premium.
    @objc private func acquirePremiumTapped() {
        delegate?.didTapAcquirePremium()
        navigationController?.popViewController(animated: true)
    }

    /// Borra los datos del usuario y navega a la pantalla de bienvenida.
    @objc private func logoutTapped() {
        UserManager.shared.clearUser()
        let welcomeVC = WelcomeViewController()
        let navigationController = UINavigationController(rootViewController: welcomeVC)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    /// Regresa a la pantalla anterior.
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
