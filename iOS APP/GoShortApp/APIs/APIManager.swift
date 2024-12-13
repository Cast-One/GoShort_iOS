//
//  APIManager.swift
//  GoShortApp


import Foundation

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    enum HTTPMethod: String {
        case GET, POST, PUT, DELETE
    }
    
    struct Endpoint {
        let path: String
        let method: HTTPMethod
        let parameters: [String: Any]?
        let headers: [String: String]?
        
        func url(baseURL: String) -> URL? {
            return URL(string: baseURL + path)
        }
    }
    
    func request<T: Decodable>(
        endpoint: Endpoint,
        baseURL: String = "https://fca-lab.online/v1",
        responseType: T.Type,
        body: Data? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = endpoint.url(baseURL: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        if let headers = endpoint.headers {
            headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        if let body = body {
            urlRequest.httpBody = body
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } else if let parameters = endpoint.parameters {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 500, userInfo: nil)))
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
