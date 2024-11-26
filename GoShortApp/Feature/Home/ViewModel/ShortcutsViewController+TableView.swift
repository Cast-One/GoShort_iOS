//
//  ShortcutsViewController+TableView.swift
//  GoShortApp
//
//  Created by Uriel C on 24/11/24.
//

import UIKit

/// Extensión de `ShortcutsViewController` para manejar las funciones relacionadas con la tabla.
extension ShortcutsViewController {

    /// Devuelve el número de filas en la sección de la tabla.
    /// - Parameters:
    ///   - tableView: La instancia de la tabla.
    ///   - section: La sección de la tabla para la que se solicita el número de filas.
    /// - Returns: El número de atajos (shortcuts) en la lista actual.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentShortcuts.count
    }

    /// Configura y devuelve la celda para la fila en un índice específico.
    /// - Parameters:
    ///   - tableView: La instancia de la tabla.
    ///   - indexPath: La posición de la celda en la tabla.
    /// - Returns: Una celda configurada con los datos de un atajo.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShortcutCell", for: indexPath) as? ShortcutTableViewCell else {
            return UITableViewCell()
        }
        
        let shortcut = currentShortcuts[indexPath.row]
        
        // Configura las acciones para copiar, abrir en navegador y compartir.
        cell.configure(
            index: indexPath.row + 1,
            name: shortcut.title,
            url: shortcut.shortURL,
            copyAction: { [weak self] in
                // Copiar la URL al portapapeles.
                UIPasteboard.general.string = shortcut.shortURL
                self?.showToast(message: LocalizableConstants.Toast.textCopied)
            },
            webAction: {
                // Abrir la URL en Safari.
                if let url = URL(string: shortcut.shortURL) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            },
            shareAction: { [weak self] in
                // Compartir la URL usando el ActivityViewController de iOS.
                let activityVC = UIActivityViewController(activityItems: [shortcut.shortURL], applicationActivities: nil)
                self?.present(activityVC, animated: true, completion: nil)
            }
        )

        return cell
    }

    /// Permite que las filas de la tabla sean editables (por ejemplo, para eliminar elementos).
    /// - Parameters:
    ///   - tableView: La instancia de la tabla.
    ///   - indexPath: La posición de la celda en la tabla.
    /// - Returns: `true` si la fila puede ser editada, `false` en caso contrario.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    /// Maneja la acción de eliminar una fila cuando el usuario desliza hacia la izquierda.
    /// - Parameters:
    ///   - tableView: La instancia de la tabla.
    ///   - editingStyle: El estilo de edición (en este caso, eliminación).
    ///   - indexPath: La posición de la celda a editar.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Primero, elimina el elemento de la lista de atajos.
            currentShortcuts.remove(at: indexPath.row)
            
            // Luego, recarga la tabla para reflejar los cambios.
            tableView.reloadData()
            showToast(message: LocalizableConstants.Toast.shortCutDeleted)
            // Actualiza la visibilidad del mensaje de placeholder.
            updatePlaceholderVisibility()
        }
    }
}
