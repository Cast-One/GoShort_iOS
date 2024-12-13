//
//  CustomURLViewController.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit
import SwiftSoup

protocol CustomURLViewControllerDelegate: AnyObject {
    func didGenerateCustomURL(controller: CustomURLViewController)
}

class CustomURLViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: CustomURLViewControllerDelegate?

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .label
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableConstants.Labels.titleCustomURL
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let headerLargeURLTextField: UILabel = {
        let label = UILabel()
        label.text = LocalizableConstants.Labels.headerLargeURL
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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

    let headerCustomNameTextField: UILabel = {
        let label = UILabel()
        label.text = LocalizableConstants.Labels.headerCustomName
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let customNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizableConstants.Placeholders.customName
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let headerDomainStackView: UILabel = {
        let label = UILabel()
        label.text = LocalizableConstants.Labels.headerDomainSelected
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let domainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let domainSuffixTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizableConstants.Placeholders.domainSuffix
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        return textField
    }()

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

    init(url: String? = nil) {
        self.initialURL = url
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    let domainPickerView = UIPickerView()
    let availableDomains = ["https://go.short/", "https://my.link/"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
        setupGradientForTitle()
        setupActions()
        
        if let url = initialURL {
            largeURLTextField.text = url
        }
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyGradient(to: generateButton, colors: [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor])
    }
    
    func applyGradient(to button: UIButton, colors: [CGColor], startPoint: CGPoint = CGPoint(x: 0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1, y: 0.5)) {
        if let gradientLayer = button.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientLayer.frame = button.bounds // Actualizar tamaño del gradiente.
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
        
        domainStackView.addArrangedSubview(domainSuffixTextField)
        
        largeURLTextField.delegate = self
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            headerLargeURLTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            headerLargeURLTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerLargeURLTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            largeURLTextField.topAnchor.constraint(equalTo: headerLargeURLTextField.bottomAnchor, constant: 10),
            largeURLTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            largeURLTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            headerCustomNameTextField.topAnchor.constraint(equalTo: largeURLTextField.bottomAnchor, constant: 20),
            headerCustomNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerCustomNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            customNameTextField.topAnchor.constraint(equalTo: headerCustomNameTextField.bottomAnchor, constant: 10),
            customNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            headerDomainStackView.topAnchor.constraint(equalTo: customNameTextField.bottomAnchor, constant: 20),
            headerDomainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerDomainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            domainStackView.topAnchor.constraint(equalTo: headerDomainStackView.bottomAnchor, constant: 10),
            domainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            domainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            domainSuffixTextField.widthAnchor.constraint(equalTo: domainStackView.widthAnchor, multiplier: 1.0),
            
            generateButton.topAnchor.constraint(equalTo: domainStackView.bottomAnchor, constant: 30),
            generateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            generateButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func setupGradientForTitle() {
        if let gradientColor = titleLabel.gradientTextColor(colors: [.systemBlue, .systemPurple], text: "Custom URL", font: UIFont.boldSystemFont(ofSize: 30)) {
            titleLabel.textColor = gradientColor
        }
    }
    
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
        
        if textField == largeURLTextField, let longURL = largeURLTextField.text, isValidURL(longURL) {
            showLoader()
            fetchTitleFromURL(longURL) { [weak self] title in
                DispatchQueue.main.async {
                    self?.hideLoader()
                    if let title = title, !title.isEmpty {
                        self?.customNameTextField.text = title
                    } else {
                        self?.customNameTextField.text = "Custom URL"
                    }
                }
            }
        }
        return true
    }
    
    @objc private func handleGenerateButton() {
        guard let longURL = largeURLTextField.text, !longURL.isEmpty, isValidURL(longURL),
              let domain = domainSuffixTextField.text  else {
            showToast(message: "Por favor ingresa datos válidos.")
            return
        }

        showLoader()

        let completion: (String) -> Void = { [weak self] title in
            guard let self = self else { return }
            let customName = title.isEmpty ? "Custom URL" : title

            let requestBody: [String: Any] = [
                "url": longURL,
                "domain": domain
            ]

            let shortenPlanEndpoint = APIManager.Endpoint(
                path: "/shorten-plan/",
                method: .POST,
                parameters: requestBody,
                headers: [
                    "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")",
                    "Content-Type": "application/json"
                ]
            )

            // Llamada al API
            APIManager.shared.request(endpoint: shortenPlanEndpoint, responseType: ShortenURLResponse.self) { result in
                DispatchQueue.main.async {
                    self.hideLoader()
                    switch result {
                    case .success(let response):
                        if response.success {
                            self.showToast(message: "URL generada: \(response.data.shortened_url)")

                            self.customNameTextField.text = customName
                            self.largeURLTextField.text = ""
                            self.domainSuffixTextField.text = ""

                            self.delegate?.didGenerateCustomURL(controller: self)
                        } else {
                            self.showToast(message: "Error: \(response.message)")
                        }
                    case .failure(let error):
                        self.showToast(message: "Error en la generación: \(error.localizedDescription)")
                    }
                }
            }
        }

        // Validar si ya se autocompletó el título
        if let customName = customNameTextField.text, !customName.isEmpty, customName != "Custom URL" {
            completion(customName)
        } else {
            fetchTitleFromURL(longURL) { title in
                completion(title ?? "Custom URL")
            }
        }
    }

    func fetchTitleFromURL(_ urlString: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            if let html = String(data: data, encoding: .utf8) {
                do {
                    let document = try SwiftSoup.parse(html)
                    let title = try document.title()
                    completion(title)
                } catch {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}

