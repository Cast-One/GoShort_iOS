//
//  WelcomeViewController.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit
import AuthenticationServices

class WelcomeViewController: UIViewController, ASAuthorizationControllerDelegate  {

    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        let fullText = "\(LocalizableConstants.Welcome.title) \(LocalizableConstants.General.nameApp)"
        
        let boldFont = UIFont.boldSystemFont(ofSize: 18)
        let regularFont = UIFont.boldSystemFont(ofSize: 24)
        let attributedText = NSMutableAttributedString(string: fullText)
        
        let range = (fullText as NSString).range(of: LocalizableConstants.Welcome.title)
        attributedText.addAttributes([
            .font: boldFont,
            .foregroundColor: UIColor.label
        ], range: range)
        
        let appNameRange = (fullText as NSString).range(of: LocalizableConstants.General.nameApp)
        attributedText.addAttributes([
            .font: regularFont,
            .foregroundColor: UIColor.systemBlue
        ], range: appNameRange)
        
        label.attributedText = attributedText
        return label
    }()

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

    lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        view.addSubview(welcomeLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(appleSignInButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            appleSignInButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 60),
            appleSignInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            appleSignInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func navigateToMainScreen() {
        self.navigationController?.viewControllers = [ShortcutsViewController()]
    }
}
