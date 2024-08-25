//
//  LoginQuery.swift
//  SeSAC5LSLPPractice
//
//  Created by jack on 7/25/24.
//

import Foundation

struct LoginQuery: Encodable {
    let email: String
    let password: String
}



struct CommentQuery: Encodable {
    let content: String
}



struct FetchReadingPostQuery: Encodable {
    let next: String?
    let limit: String
    let product_id: String
    
    
}


//MARK: -  포스트 조회
struct PostsResponse: Codable {
    let data: [PostsModel]
    let nextCursor: String?
}


//MARK: - 포스트 이미지 업로드

struct PostImageModel: Decodable {
    let files: [String]
}


struct ImageUploadQuery: Encodable {
    let files: Data
}

struct PostQuery: Encodable {
    let title: String
    let content: String
    let content1: String
    let product_id: String
    let files: [String]
}

struct PostsModel: Codable {
    let postId: String            // 게시글 ID
    let productId: String?        // 제품 ID (선택적)
    let title: String?            // 게시글 제목 (선택적)
    let content: String?          // 게시글 본문 (선택적)
    let content1: String?         // 추가 콘텐츠 필드 (선택적)
    let content2: String?         // 추가 콘텐츠 필드 (선택적)
    let content3: String?         // 추가 콘텐츠 필드 (선택적)
    let content4: String?         // 추가 콘텐츠 필드 (선택적)
    let content5: String?         // 추가 콘텐츠 필드 (선택적)
    let createdAt: String         // 생성 날짜
    let creator: Creator          // 작성자 정보
    let files: [String]?          // 이미지 파일 경로 목록 (선택적)
    let likes: [String]?          // 좋아요 목록 (선택적)
    let likes2: [String]?         // 추가 좋아요 목록 (선택적)
    let hashTags: [String]?       // 해시태그 목록 (선택적)
    var comments: [Comment]     // 댓글 목록 (선택적)
    
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
    let userId: String             // 작성자 ID
    let nick: String               // 작성자 닉네임
    let profileImage: String?      // 프로필 이미지 (선택적)
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}

struct Comment: Codable {
    let commentId: String          // 댓글 ID
    let content: String            // 댓글 내용
    let createdAt: String          // 댓글 작성 날짜
    let creator: Creator           // 댓글 작성자 정보
    
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




struct Mission {
    let iconName: String
    let title: String
    let carrotCount: Int
}

struct MissionData {
    static let missions: [Mission] = [
        Mission(iconName: "icon1", title: "망한 사진 월드컵 대회참여하기", carrotCount: 2),
        Mission(iconName: "icon2", title: "후보 구경하기", carrotCount: 3)
    ]
}

struct Pet {
    let name: String
    let userName: String
    let imageURL: String
}
