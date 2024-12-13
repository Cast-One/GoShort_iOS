//
//  User.swift
//  GoShortApp
//
//  Created by Uriel C on 24/11/24.
//

struct UserDataResponse: Decodable {
    let success: Bool
    let message: String
    let data: User
    let trace_id: String
}

struct User: Decodable {
    let username: String
    let email: String
    let id: String
}
