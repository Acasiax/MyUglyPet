//
//  ProfileDTO.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//

import Foundation

// MARK: - 내 프로필 조회 응답
struct MyProfileResponse: Codable {
    let user_id: String
    let email: String?
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    let profileImage: String?
    let followers: [MyUser]
    let following: [MyUser]
    let posts: [String]
}

// MARK: - 내 프로필
struct MyUser: Codable {
    let user_id: String
    let nick: String
    let profileImage: String?
}

struct RegistrationResponse: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
}


struct ProfileModel: Decodable {
    let id: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email, nick
    }
}

// MARK: - 팔로우 응답(사용안함)
struct FollowResponse: Codable {
    let nick: String
    let opponent_nick: String
    let following_status: Bool
}

//MARK: - 이메일 중복 확인
struct EmailValidationResponse: Codable {
    let message: String
}
