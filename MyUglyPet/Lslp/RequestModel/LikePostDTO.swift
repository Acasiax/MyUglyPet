//
//  LikePostDTO.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//

import Foundation

// MARK: - 포스트 좋아요 설정
struct LikePostQuery: Codable {
    let like_status: Bool
}

struct FetchLikedPostsQuery {
    let next: String?
    let limit: String?
}
