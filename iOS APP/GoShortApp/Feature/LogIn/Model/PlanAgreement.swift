//
//  PlanAgreement.swift
//  GoShortApp
//

struct PlanAgreementResponse: Decodable {
    let success: Bool
    let message: String
    let data: AgreementData
    let trace_id: String
}

struct AgreementData: Decodable {
    let plan_agreements: [PlanAgreement]
}

struct PlanAgreement: Codable {
    let id: String
    let plan_id: String
    let user_id: String
    let start_date: String
    let end_date: String
}


struct PlansResponse: Decodable {
    let success: Bool
    let message: String
    let data: PlanData
}

struct PlanData: Decodable {
    let plans: [Plan]
}

struct Plan: Decodable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let duration_months: Int
}
