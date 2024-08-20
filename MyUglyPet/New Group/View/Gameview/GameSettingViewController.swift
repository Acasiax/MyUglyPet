//
//  GameSettingViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/21/24.
//

import UIKit
import Alamofire

class GameSettingViewController: UIViewController {

    private var serverUglyCandidatePosts: [PostsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchPosts()
    }
    
    
    private func fetchPosts() {
        // 쿼리 파라미터 생성
        let query = FetchReadingPostQuery(next: nil, limit: "30", product_id: "못난이후보등록")

        // 네트워크 요청 예시 (PostNetworkManager 사용)
        PostNetworkManager.shared.fetchPosts(query: query) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.serverUglyCandidatePosts = posts
               
                print("🎮게임후보 포스팅을 가져오는데 성공했어요")
            case .failure(let error):
                print("🎮게임후보 포스팅을 가져오는데 실패했어요ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }
}
