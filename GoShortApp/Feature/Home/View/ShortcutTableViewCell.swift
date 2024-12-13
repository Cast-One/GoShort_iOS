//
//  ShortcutTableViewCell.swift
//  GoShortApp
//
//  Created by Uriel C on 24/11/24.
//

import UIKit

class ShortcutTableViewCell: UITableViewCell {

    let indexLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let urlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "clipboard"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray
        return button
    }()
    
    let webButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "network"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBlue
        return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func truncatedText(_ text: String, maxLength: Int = 25) -> String {
        if text.count > maxLength {
            let index = text.index(text.startIndex, offsetBy: maxLength)
            return String(text[..<index]) + "..."
        }
        return text
    }
    func truncatedUrl(_ text: String, maxLength: Int = 40) -> String {
        if text.count > maxLength {
            let index = text.index(text.startIndex, offsetBy: maxLength)
            return String(text[..<index]) + ""
        }
        return text
    }
    private func setupLayout() {
        contentView.addSubview(indexLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(urlLabel)
        contentView.addSubview(copyButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(webButton)

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

    func configure(index: Int, name: String, url: String, copyAction: @escaping () -> Void, webAction: @escaping () -> Void, shareAction: @escaping () -> Void) {
        indexLabel.text = "\(index)"
        urlLabel.text = truncatedUrl(url)
        nameLabel.text = truncatedText(name)

        copyButton.addAction(UIAction(handler: { _ in copyAction() }), for: .touchUpInside)
        webButton.addAction(UIAction(handler: { _ in webAction() }), for: .touchUpInside)
        shareButton.addAction(UIAction(handler: { _ in shareAction() }), for: .touchUpInside)
    }
}
