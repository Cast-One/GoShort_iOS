//
//  URLResponse.swift
//  GoShortApp
//
struct URLResponse: Decodable {
    let success: Bool
    let message: String
    let data: URLData
}

struct URLData: Decodable {
    let urls: [URLInfo]
}

struct URLInfo: Decodable {
    let shortened_url: String
    let original_url: String
    let domain: String?
    let user_id: String
}

struct ShortenURLResponse: Codable {
    let success: Bool
    let message: String
    let data: ShortenedData
}

struct ShortenedData: Codable {
    let shortened_url: String
}
