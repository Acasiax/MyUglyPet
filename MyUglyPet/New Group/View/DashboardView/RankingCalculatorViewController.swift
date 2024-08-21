//
//  RankingCalculatorViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/21/24.
//

import UIKit
import Alamofire
import Kingfisher


struct FetchHashtagReadingPostQuery: Encodable {
    let next: String?
    let limit: String
    let product_id: String
    let hashTag: String?
}



// 포스트 그룹을 정의하는 구조체
struct PostGroup: Hashable {
    let title: String
    let content: String
    let content1: String
    // files는 비교에서 제외됩니다.
}

class RankingCalculatorViewController: UIViewController {

    private var winnerPets: [Pet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("=============")
        fetchHashtagPosts(hashTag: "1등이닷") // 해시태그를 사용하여 포스팅을 가져옵니다.
    }
}

extension RankingCalculatorViewController {

    // 해시태그를 사용하여 포스팅 가져오기
    private func fetchHashtagPosts(hashTag: String) {
        let query = FetchHashtagReadingPostQuery(next: nil, limit: "30", product_id: "각유저가고른1등우승자", hashTag: hashTag)

        PostNetworkManager.shared.fetchHashtagPosts(query: query) { [weak self] result in
            switch result {
            case .success(let posts):
                // 모든 포스트 출력
                self?.printAllPosts(posts)
                // 포스트를 처리하여 랭킹 계산
                self?.processFetchedPosts(posts)
            case .failure(let error):
                print("해시태그로 포스팅을 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }

    // 모든 포스트를 출력
    private func printAllPosts(_ posts: [PostsModel]) {
        for (index, post) in posts.enumerated() {
            print("===== 포스트 \(index + 1) =====")
            print("포스트 타이틀: \(post.title ?? "제목 없음")")
            print("포스트 내용: \(post.content ?? "내용 없음")")
            print("포스트 내용1: \(post.content1 ?? "내용1 없음")")
            print("포스트 파일 URL들: \(post.files ?? [])")
            print("========================\n")
        }
    }

    // 가져온 포스트를 처리
    private func processFetchedPosts(_ posts: [PostsModel]) {
        // 포스트를 그룹화하여 개수를 계산
        let groupedPosts = groupPosts(posts: posts)
        
        // 개수로 정렬하여 순위를 매김
        let rankedGroups = rankGroups(groupedPosts)
        
        // 모든 순위 출력
        displayRankedGroups(rankedGroups)
    }

    // 포스트를 그룹화하여 중복 개수 계산
    private func groupPosts(posts: [PostsModel]) -> [PostGroup: [PostsModel]] {
        var groupedPosts = [PostGroup: [PostsModel]]()
        
        for post in posts {
            let postGroup = PostGroup(
                title: post.title ?? "제목 없음",
                content: post.content ?? "내용 없음",
                content1: post.content1 ?? "내용1 없음"
            )
            
            groupedPosts[postGroup, default: []].append(post)
        }
        
        return groupedPosts
    }

    // 그룹화된 포스트를 개수로 정렬하여 순위를 매김
    private func rankGroups(_ groupedPosts: [PostGroup: [PostsModel]]) -> [(key: PostGroup, value: [PostsModel])] {
        return groupedPosts.sorted { $0.value.count > $1.value.count }
    }

    // 모든 순위 출력
    private func displayRankedGroups(_ rankedGroups: [(key: PostGroup, value: [PostsModel])]) {
        guard !rankedGroups.isEmpty else {
            print("랭킹에 표시할 그룹이 없습니다.")
            return
        }
        
        for (index, group) in rankedGroups.enumerated() {
            print("\(index + 1)등 그룹의 타이틀: \(group.key.title)")
            print("\(index + 1)등 그룹의 내용: \(group.key.content)")
            print("\(index + 1)등 그룹의 내용1: \(group.key.content1)")
            print("\(index + 1)등 그룹의 중복된 포스트 개수: \(group.value.count)개") // 해당 그룹에 몇 개의 포스트가 있는지 출력

            // 그룹에 포함된 포스트들을 모두 출력
            for (postIndex, post) in group.value.enumerated() {
                print("    포함된 포스트 \(postIndex + 1): 타이틀: \(post.title ?? "제목 없음"), 파일 URL: \(post.files ?? [])")
            }
            
            print("========================\n")
        }
    }
}
