//
//  ProfileViewController.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func didTapAcquirePremium()
}

class ProfileViewController: UIViewController {

    weak var delegate: ProfileViewControllerDelegate?

    let numURLsRequest: Int

    init(numURLsRequest: Int) {
        self.numURLsRequest = numURLsRequest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .label
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let urlsGeneratedView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let urlsGeneratedLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableConstants.Profile.urls_generated
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let urlsGeneratedCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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

    let premiumStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
        loadUserData()
    }

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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        applyGradient(to: premiumButton, colors: [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor])

        let statusText = UserDefaultsManager.shared.isPremiumUser() == true
            ? LocalizableConstants.Profile.premium_status_yes
            : LocalizableConstants.Profile.premium_status_no
        applyGradientToLabel(
            label: premiumStatusLabel,
            text: statusText,
            colors: [.systemBlue, .systemPurple],
            font: UIFont.systemFont(ofSize: 14)
        )
    }
    
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

    func applyGradientToLabel(label: UILabel, text: String, colors: [UIColor], font: UIFont) {
        label.text = text
        label.font = font
        label.sizeToFit()

        guard label.bounds.size != .zero else { return }

        let renderer = UIGraphicsImageRenderer(size: label.bounds.size)
        let gradientImage = renderer.image { context in
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = colors.map { $0.cgColor }
            gradientLayer.frame = CGRect(origin: .zero, size: label.bounds.size)
            gradientLayer.render(in: context.cgContext)
        }

        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(patternImage: gradientImage),
            .font: font
        ]
        label.attributedText = NSAttributedString(string: text, attributes: textAttributes)
    }

    private func setupConstraints() {
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

        if UserDefaultsManager.shared.isPremiumUser() {
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

    private func loadUserData() {
        let user = UserDefaultsManager.shared.getUser()
        nameLabel.text =  "User ID: \(String(user.username.prefix(6)))"
        usernameLabel.text = user.email
        urlsGeneratedCountLabel.text = "\(numURLsRequest)"
    }

    @objc private func acquirePremiumTapped() {
        delegate?.didTapAcquirePremium()
        navigationController?.popViewController(animated: true)
    }

    @objc private func logoutTapped() {
        UserManager.shared.clearUser()
        UserDefaultsManager.shared.clearAllData()

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let welcomeVC = WelcomeViewController()
            let navigationController = UINavigationController(rootViewController: welcomeVC)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
