//
//  WelcomeViewController.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit
import AuthenticationServices

class WelcomeViewController: UIViewController {

    // MARK: - UI Elements

    /// Etiqueta de bienvenida
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Texto del título basado en el estado del usuario (Free o Premium).
        var fullText = "\(LocalizableConstants.Welcome.title) \(LocalizableConstants.General.nameApp)"
        
        // Fuente y atributos
        let boldFont = UIFont.boldSystemFont(ofSize: 18)
        let regularFont = UIFont.boldSystemFont(ofSize: 24)
        
        // Crear texto estilizado
        let attributedText = NSMutableAttributedString(string: fullText)
        
        // Aplicar negrita a "Free" o "Premium"
        if let user = UserManager.shared.getUser() {
            let range = (fullText as NSString).range(of: LocalizableConstants.Welcome.title)
            attributedText.addAttributes([
                .font: boldFont,
                .foregroundColor: UIColor.label
            ], range: range)
        } else {
            let range = (fullText as NSString).range(of: LocalizableConstants.Welcome.title)
            attributedText.addAttributes([
                .font: boldFont,
                .foregroundColor: UIColor.label
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

    /// Descripción
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableConstants.Welcome.subtitle
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Botón de inicio de sesión con Apple
    lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
        return button
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }

    // MARK: - Setup

    /// Agrega subviews a la vista principal
    private func setupSubviews() {
        view.addSubview(welcomeLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(appleSignInButton)
    }

    /// Configura las constraints para los elementos de la vista
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Título
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Descripción
            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Botón de inicio de sesión con Apple
            appleSignInButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 60),
            appleSignInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            appleSignInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Actions

    /// Maneja el inicio de sesión con Apple
    @objc private func handleAppleSignIn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}
