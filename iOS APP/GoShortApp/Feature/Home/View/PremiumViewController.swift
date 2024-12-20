//
//  PremiumViewController.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit

protocol PremiumViewControllerDelegate: AnyObject {
    func didBecomePremium(controller: PremiumViewController)
}

class PremiumViewController: UIViewController {

    let premiumPlanID: String

    init(premiumPlanID: String) {
        self.premiumPlanID = premiumPlanID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        var fullText = "\(LocalizableConstants.Labels.titleLabelPreimum) \(LocalizableConstants.General.nameApp)"
        
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let regularFont = UIFont.boldSystemFont(ofSize: 26)
        let attributedText = NSMutableAttributedString(string: fullText)
        
        let premiumRange = (fullText as NSString).range(of: LocalizableConstants.Labels.titleLabelPreimum)
        attributedText.addAttributes([
            .font: boldFont,
            .foregroundColor: UIColor.label
        ], range: premiumRange)
        
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

    let featuresTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        let text = """
       \(LocalizableConstants.Premium.featuresIntro)

       \(LocalizableConstants.Premium.featureLimitlessLinks)
       \(LocalizableConstants.Premium.featureCustomizeLinks)
       \(LocalizableConstants.Premium.featureTrafficStats)
       \(LocalizableConstants.Premium.featureSecureLinks)
       \(LocalizableConstants.Premium.featureExpiration)
       \(LocalizableConstants.Premium.featureAdFree)
       \(LocalizableConstants.Premium.featurePrioritySupport)
       """

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.lineSpacing = 4
        let attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .paragraphStyle: paragraphStyle
            ]
        )
        
        textView.attributedText = attributedText
        textView.textAlignment = .justified
        textView.textColor = .label
        return textView
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        let baseAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.label
        ]
        let priceAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.systemPurple
        ]
        let attributedText = NSMutableAttributedString(
            string: LocalizableConstants.Premium.priceText,
            attributes: baseAttributes
        )
        attributedText.append(NSAttributedString(string: LocalizableConstants.Premium.priceValue, attributes: priceAttributes))
        attributedText.append(NSAttributedString(string: LocalizableConstants.Premium.priceMonthly, attributes: baseAttributes))
        label.attributedText = attributedText
        return label
    }()

    let subscribeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizableConstants.Premium.subscribeButton, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(subscribeTapped), for: .touchUpInside)
        return button
    }()

    let termsLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableConstants.Premium.terms
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    weak var delegate: PremiumViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupViews()
        setupGradientForButton()
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(featuresTextView)
        view.addSubview(subscribeButton)
        view.addSubview(termsLabel)
        view.addSubview(priceLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            featuresTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            featuresTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            featuresTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            termsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            termsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            termsLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            subscribeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            subscribeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            subscribeButton.heightAnchor.constraint(equalToConstant: 50),
            subscribeButton.bottomAnchor.constraint(equalTo: termsLabel.topAnchor, constant: -20),

            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: subscribeButton.topAnchor, constant: -10),
        ])
    }

    private func setupGradientForButton() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = subscribeButton.bounds
        gradientLayer.cornerRadius = 10
        subscribeButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        subscribeButton.layer.sublayers?.first?.frame = subscribeButton.bounds
    }
}
