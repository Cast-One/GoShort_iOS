//
//  ShortcutsViewController.swift
//  GoShortApp
//
//  Created by Uriel C on 24/11/24.
//

import UIKit

class ShortcutsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var urlList: [URLInfo] = []
    private var urlCustomList: [URLInfo] = []
    
    var isPremiumUser = false {
        didSet {
            
            let fullText = "\(isPremiumUser ? LocalizableConstants.Labels.titleLabelPreimum : LocalizableConstants.Labels.titleLabelFree) \(LocalizableConstants.General.nameApp)"
            
            let boldFont = UIFont.boldSystemFont(ofSize: 18)
            let regularFont = UIFont.boldSystemFont(ofSize: 24)
            
            let attributedText = NSMutableAttributedString(string: fullText)
            
            let range = (fullText as NSString).range(of: isPremiumUser ? LocalizableConstants.Labels.titleLabelPreimum : LocalizableConstants.Labels.titleLabelFree)
             attributedText.addAttributes([
                 .font: boldFont,
                 .foregroundColor: UIColor.label
             ], range: range)
            
            let appNameRange = (fullText as NSString).range(of: LocalizableConstants.General.nameApp)
            if let gradientColor = titleLabel.gradientTextColor(colors: [.systemBlue, .systemPurple], text: LocalizableConstants.General.nameApp, font: regularFont) {
                attributedText.addAttributes([
                    .font: regularFont,
                    .foregroundColor: gradientColor
                ], range: appNameRange)
            }
            
            titleLabel.attributedText = attributedText
            
            
        }
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let headerUrlTextField: UILabel = {
        let label = UILabel()
        label.text = LocalizableConstants.Labels.urlHeaderText
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let urlTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizableConstants.Labels.urlPlaceholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = .URL
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let shortenButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBackground
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitle(LocalizableConstants.Buttons.shortenButtonTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = false

        return button
    }()

    let customButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizableConstants.Buttons.customButtonTitle, for: .normal)
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

    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [LocalizableConstants.SegmentedControl.shortcuts, LocalizableConstants.SegmentedControl.customShortcuts])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ShortcutCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

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

    let premiumButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizableConstants.Buttons.premiumButtonTitle, for: .normal)
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
    
    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        button.tintColor = .label // Cambiar color del ícono si es necesario
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()

    var currentShortcuts: [URLInfo] = [] {
        didSet {
            self.tableView.reloadData()
            self.updatePlaceholderVisibility()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.isHidden = true
        
        self.isPremiumUser = UserDefaultsManager.shared.isPremiumUser()
        
        fetchURLsFromAPI() 
        
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

    func getTotalURLsCount() -> Int {
        return urlList.count + urlCustomList.count
    }
    
    func fetchURLsFromAPI() {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else { return }
        
        let urlsEndpoint = APIManager.Endpoint(
            path: "/urls",
            method: .GET,
            parameters: nil,
            headers: ["Authorization": "Bearer \(token)", "Accept": "application/json"]
        )
        
        DispatchQueue.main.async {
            self.showLoader()
        }
        
        APIManager.shared.request(endpoint: urlsEndpoint, responseType: URLResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            self.updatePlaceholderVisibility()

            switch result {
            case .success(let response):
                if response.success {
                    self.urlList = response.data.urls.filter { $0.domain == nil }
                    self.urlCustomList = response.data.urls.filter { $0.domain != nil }
                    
                    DispatchQueue.main.async {
                        self.hideLoader()
                        self.currentShortcuts = self.urlList.reversed()
                        self.tableView.reloadData()
                        self.updatePlaceholderVisibility()
                    }
                }
            case .failure(_):
                break
            }
        }
    }

    func fetchPremiumPlanID(completion: @escaping (String?) -> Void) {
        let plansEndpoint = APIManager.Endpoint(
            path: "/plans/",
            method: .GET,
            parameters: nil,
            headers: ["Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"]
        )

        APIManager.shared.request(endpoint: plansEndpoint, responseType: PlansResponse.self) { result in
            switch result {
            case .success(let response):
                if response.success {
                    let premiumPlan = response.data.plans.first { $0.name == "Premium" }
                    completion(premiumPlan?.id)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                completion(nil)
            }
        }
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        applyGradient(to: customButton, colors: [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor])
        applyGradient(to: premiumButton, colors: [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor])
    }

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
    
    func updatePlaceholderVisibility() {
        emptyPlaceholderLabel.isHidden = !currentShortcuts.isEmpty
    }

    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentShortcuts = urlList
        } else {
            currentShortcuts = urlCustomList
        }
    }
    
    @objc func premiumClicked() {
        presentPremiumViewController()
    }
    
    @objc func customUrlClicked() {
        let controller = CustomURLViewController(url: self.urlTextField.text ?? "")
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func profileButtonTapped() {
        let controller = ProfileViewController(numURLsRequest: 200)
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

