//
//  LoginDTO.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//

import Foundation

struct LoginQuery: Encodable {
    let email: String
    let password: String
}

struct RefreshModel: Decodable {
    let accessToken: String
}

struct LoginModel: Decodable {
    let id: String
    let email: String
    let nick: String
    let profile: String?
    let access: String
    let refresh: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email, nick
        case profile = "profileImage"
        case access = "accessToken"
        case refresh = "refreshToken"
    }
}
