//
//  PostDTO.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//

import Foundation
import UIKit


// MARK: - 게시글 조회 쿼리
struct FetchReadingPostQuery: Encodable {
    let next: String?
    let limit: String
    let product_id: String
    
}

// MARK: - 해시태그 조회 쿼리
struct FetchHashtagReadingPostQuery: Encodable {
    let next: String?
    let limit: String
    let product_id: String
    let hashTag: String?
}

//MARK: - 이미지 업로드 쿼리
struct ImageUploadQuery: Encodable {
    let files: Data
}

//MARK: - 포스트 이미지 업로드
struct PostImageModel: Decodable {
    let files: [String]
}

//MARK: - 포스트 전체 응답 쿼리
struct PostQuery: Encodable {
    let title: String
    let content: String
    let content1: String
    let product_id: String
    let files: [String]
}

struct PostsModel: Codable {
    let postId: String
    let productId: String?
    var title: String?
    var content: String?
    var content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let createdAt: String
    let creator: Creator
    let files: [String]?
    let likes: [String]?
    let likes2: [String]?
    let hashTags: [String]?
    var comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case title
        case content
        case content1
        case content2
        case content3
        case content4
        case content5
        case createdAt
        case creator
        case files
        case likes
        case likes2
        case hashTags = "hashTags"
        case comments
    }
}

struct Creator: Codable {
    let userId: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}

//MARK: -  포스트 조회
struct PostsResponse: Codable {
    let data: [PostsModel]
    let nextCursor: String?
}


