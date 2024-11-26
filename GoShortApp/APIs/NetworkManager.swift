//
//  NetworkManager.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import Foundation

/// Clase genérica para manejar todas las llamadas a APIs.
class NetworkManager {
    
    /// Singleton para acceder al `NetworkManager` desde cualquier parte.
    static let shared = NetworkManager()
    private init() {}
    
    /// Realiza una solicitud GET a un endpoint de API.
    /// - Parameters:
    ///   - url: URL completa de la API.
    ///   - responseType: Tipo de datos que esperas como respuesta (debe conformar a `Codable`).
    ///   - completion: Cierre con el resultado de tipo genérico `T` o un error.
    func fetch<T: Codable>(url: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "URL inválida", code: 400, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Sin datos", code: 404, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
