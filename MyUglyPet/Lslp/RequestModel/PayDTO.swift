//
//  PayDTO.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//

import Foundation


// MARK: - 전체 응답을 나타내는 구조체
struct PaymentHistoryListValidationResponse: Decodable {
    let data: [PaymentHistory]
}


// MARK: -  개별 결제 내역을 나타내는 구조체
struct PaymentHistory: Decodable {
    let buyerID: String
    let postID: String
    let merchantUID: String
    let productName: String
    let price: Int
    let paidAt: String
    
    enum CodingKeys: String, CodingKey {
        case buyerID = "buyer_id"
        case postID = "post_id"
        case merchantUID = "merchant_uid"
        case productName = "productName"
        case price
        case paidAt = "paidAt"
    }
}


// MARK: -  영수증 검증 응답 코드
struct ReceiptValidationResponse: Codable {
    let buyer_id: String
    let post_id: String
    let merchant_uid: String
    let productName: String
    let price: Int
    let paidAt: String
}


// MARK: - 영수증 검증 쿼리
struct ValidateReceiptQuery: Codable {
    let imp_uid: String
    let post_id: String
}
