//
//  ShortcutsViewController+TableView.swift
//  GoShortApp
//
//  Created by Uriel C on 24/11/24.
//

import UIKit
import SwiftSoup

extension ShortcutsViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentShortcuts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShortcutCell", for: indexPath) as? ShortcutTableViewCell else {
            return UITableViewCell()
        }
        
        let shortcut = currentShortcuts[indexPath.row]
        
        cell.configure(
            index: indexPath.row + 1,
            name: "Loading...",
            url: shortcut.shortened_url,
            copyAction: { [weak self] in
                UIPasteboard.general.string = shortcut.shortened_url
                self?.showToast(message: LocalizableConstants.Toast.textCopied)
            },
            webAction: {
                if let url = URL(string: shortcut.shortened_url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            },
            shareAction: { [weak self] in
                let activityVC = UIActivityViewController(activityItems: [shortcut.shortened_url], applicationActivities: nil)
                self?.present(activityVC, animated: true, completion: nil)
            }
        )
        
        fetchTitleFromURL(shortcut.original_url) { [weak cell] title in
            DispatchQueue.main.async {
                guard let title = title else { return }
                cell?.configure(
                    index: indexPath.row + 1,
                    name: title, 
                    url: shortcut.shortened_url,
                    copyAction: { [weak self] in
                        UIPasteboard.general.string = shortcut.shortened_url
                        self?.showToast(message: LocalizableConstants.Toast.textCopied)
                    },
                    webAction: {
                        if let url = URL(string: shortcut.shortened_url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    },
                    shareAction: { [weak self] in
                        let activityVC = UIActivityViewController(activityItems: [shortcut.shortened_url], applicationActivities: nil)
                        self?.present(activityVC, animated: true, completion: nil)
                    }
                )
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            currentShortcuts.remove(at: indexPath.row)
            
            tableView.reloadData()
            showToast(message: LocalizableConstants.Toast.shortCutDeleted)
            updatePlaceholderVisibility()
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
