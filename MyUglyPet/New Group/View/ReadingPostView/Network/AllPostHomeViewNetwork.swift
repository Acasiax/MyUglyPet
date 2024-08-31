//
//  AllPostHomeViewNetwork.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/31/24.
//

import Foundation

extension AllPostHomeViewController {
    func fetchMyProfile() {
        FollowPostNetworkManager.shared.fetchMyProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.myProfile = profile
            case .failure(let error):
                print("내 프로필 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchPosts() {
        let query = FetchReadingPostQuery(next: nil, limit: "30", product_id: "allFeed")
        
        PostNetworkManager.shared.fetchPosts(query: query) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.serverPosts = posts
                self?.tableView.reloadData()
            case .failure(let error):
                print("포스팅을 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }
}

