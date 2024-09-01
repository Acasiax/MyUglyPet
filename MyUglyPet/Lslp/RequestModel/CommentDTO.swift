//
//  CommentDTO.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//

import UIKit

struct CommentQuery: Encodable {
    let content: String
}

struct Comment: Codable {
    let commentId: String
    var content: String
    let createdAt: String
    let creator: Creator
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt
        case creator
    }

}

//MARK: - 댓글
struct CommentResponse: Codable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: CommentCreator
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt
        case creator
    }
}

struct CommentCreator: Codable {
    let userId: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
    }
}


struct DummyComment {
    let profileImage: UIImage?
    let username: String
    let date: String
    let text: String
}

struct UserComment {
    let profileImage: UIImage?
    let username: String
    let date: String
    let text: String
}
