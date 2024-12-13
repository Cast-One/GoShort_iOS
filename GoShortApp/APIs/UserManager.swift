//
//  UserManager.swift
//  GoShortApp
//
//  Created by Uriel C on 24/11/24.
//

import Foundation

class UserManager {
    // Singleton para usar esta clase en cualquier lugar de la app
    static let shared = UserManager()
    private let userDefaults = UserDefaults.standard

    // Claves para guardar los datos del usuario
    private let userNameKey = "userName"
    private let userPhoneKey = "userPhone"
    private let userIsPremiumKey = "userIsPremium"
    private let urlsCreatedKey = "urlsCreated"

    private init() {} // Privado para que no pueda instanciarse directamente

    // Guardar datos del usuario
    func saveUser(user: User) {
      /*  userDefaults.set(user.name, forKey: userNameKey)
        userDefaults.set(user.phone, forKey: userPhoneKey)
        userDefaults.set(user.isPremium, forKey: userIsPremiumKey)
        userDefaults.set(user.urlsCreated, forKey: urlsCreatedKey)*/
    }

    // Obtener los datos del usuario
    func getUser() -> User? {
        guard let name = userDefaults.string(forKey: userNameKey),
              let phone = userDefaults.string(forKey: userPhoneKey) else {
            return nil
        }
        let isPremium = userDefaults.bool(forKey: userIsPremiumKey)
        let urlsCreated = userDefaults.integer(forKey: urlsCreatedKey)
        return nil
    }

    // Actualizar el número de URLs creadas
    func incrementURLsCreated() {
        guard var user = getUser() else { return }
       // user.urlsCreated += 1
        //ShortcutManager.shared.incrementShortcutsCount()
        saveUser(user: user)
    }
    
    // Activar versión premium al usuario
    func premiumUser() {
        guard var user = getUser() else { return }
       // user.isPremium = true
        saveUser(user: user)
    }

    // Borrar los datos del usuario
    func clearUser() {
        userDefaults.removeObject(forKey: userNameKey)
        userDefaults.removeObject(forKey: userPhoneKey)
        userDefaults.removeObject(forKey: userIsPremiumKey)
        userDefaults.removeObject(forKey: urlsCreatedKey)
    }
}
