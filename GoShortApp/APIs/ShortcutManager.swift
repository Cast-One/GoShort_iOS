//
//  ShortcutManager.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import Foundation

/// Clase para gestionar el número de shortcuts generados.
/// Utiliza `NSUbiquitousKeyValueStore` para guardar los datos en iCloud y mantenerlos persistentes incluso si la app se reinstala.
class ShortcutManager {
    // MARK: - Singleton
    static let shared = ShortcutManager()
    
    // Clave para identificar el valor almacenado en iCloud
    private let iCloudKey = "totalShortcutsGenerated"
    
    // Acceso al almacén de iCloud
    private var iCloudStore: NSUbiquitousKeyValueStore {
        return NSUbiquitousKeyValueStore.default
    }
    
    /// Incrementa el contador de shortcuts generados.
    func incrementShortcutsCount() {
        let currentCount = getShortcutsCount()
        iCloudStore.set(currentCount + 1, forKey: iCloudKey)
        iCloudStore.synchronize()
    }
    
    /// Obtiene el contador actual de shortcuts generados.
    /// - Returns: El número total de shortcuts generados.
    func getShortcutsCount() -> Int {
        return Int(iCloudStore.longLong(forKey: iCloudKey) ?? 0) // Usa 0 como valor predeterminado si no existe.
    }
    
    /// Restablece el contador (por propósitos de desarrollo o premium).
    func resetShortcutsCount() {
        iCloudStore.set(0, forKey: iCloudKey)
        iCloudStore.synchronize()
    }
    
    func incrementShortcutsCountBy(times: Int) {
        guard times > 0 else { return } // Asegúrate de que el número de veces sea positivo
        for _ in 1...times {
            incrementShortcutsCount()
        }
    }
}

/*
 ShortcutManager.shared.incrementShortcutsCount()
 ShortcutManager.shared.resetShortcutsCount()
 let totalShortcuts = ShortcutManager.shared.getShortcutsCount()
 */
