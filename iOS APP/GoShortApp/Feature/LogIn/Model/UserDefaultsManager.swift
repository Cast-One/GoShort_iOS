//
//  UserDefaultsManager.swift
//  GoShortApp
//

import UIKit

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}

    func getUser() -> User {
        let userDefaults = UserDefaults.standard
        let username = userDefaults.string(forKey: "username") ?? ""
        let email = userDefaults.string(forKey: "email") ?? ""
        let id = userDefaults.string(forKey: "userID") ?? ""
        return User(username: username, email: email, id: id)
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }

    func isUserLoggedIn() -> Bool {
        return getAccessToken() != nil
    }
    
    func hasUserAgreements() -> Bool {
        return !getUserPlanAgreements().isEmpty
    }
    
    func saveUserPlanAgreements(_ agreements: [PlanAgreement]) {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(agreements)
            UserDefaults.standard.set(encodedData, forKey: "userPlanAgreements")
        } catch {
            print("Error al guardar acuerdos en UserDefaults: \(error.localizedDescription)")
        }
    }

    func getUserPlanAgreements() -> [PlanAgreement] {
        if let data = UserDefaults.standard.data(forKey: "userPlanAgreements") {
            let decoder = JSONDecoder()
            do {
                return try decoder.decode([PlanAgreement].self, from: data)
            } catch {
                print("Error al decodificar los acuerdos: \(error.localizedDescription)")
            }
        }
        return []
    }

    func isPremiumUser() -> Bool {
        let premiumPlanID = "aebe15ff-f6a0-4171-823f-c63cc60ef893"
        let agreements = getUserPlanAgreements()
        return agreements.contains { $0.plan_id == premiumPlanID }
    }

    func clearAllData() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "userID")
        defaults.removeObject(forKey: "accessToken")
        defaults.removeObject(forKey: "userPlanAgreements")
        defaults.synchronize()
    }
}
