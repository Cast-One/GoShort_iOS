//
//  Login&Register.swift
//  GoShortApp
//

struct RegisterResponse: Decodable {
    let success: Bool
    let message: String
    let data: RegisterData?
    let trace_id: String?
}

struct RegisterData: Decodable {
    let internal_error: InternalError?
}

struct InternalError: Decodable {
    let code: Int
    let description: String
}

struct LoginResponse: Decodable {
    let success: Bool
    let message: String
    let data: TokenData
    let trace_id: String
}

struct TokenData: Decodable {
    let access_token: String
    let token_type: String
}
