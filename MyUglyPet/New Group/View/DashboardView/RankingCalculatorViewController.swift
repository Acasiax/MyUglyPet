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



class RankingCalculatorViewController: UIViewController {

    private var winnerPets: [Pet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts() // 뷰가 로드될 때 우승자 포스팅을 가져옵니다.
    }
}

extension RankingCalculatorViewController {
    
    // 우승자 포스팅 가져오기
    private func fetchPosts() {
        // 쿼리 파라미터 생성
        let query = FetchReadingPostQuery(next: nil, limit: "30", product_id: "각유저가고른1등우승자")

        // 네트워크 요청 예시 (PostNetworkManager 사용)
        PostNetworkManager.shared.fetchPosts(query: query) { [weak self] result in
            switch result {
            case .success(let posts):
                // 가져온 포스트를 Pet 객체로 변환하여 winnerPets에 저장
                self?.winnerPets = posts.compactMap { post in
                    guard let imageUrlString = post.files?.first else {
                        print("포스트에 이미지 URL이 없습니다: \(post.title ?? "제목 없음")")
                        return nil
                    }
                    let fullImageURLString = APIKey.baseURL + "v1/" + imageUrlString
                    return Pet(
                        name: post.title ?? "기본 이름",
                        userName: post.content1 ?? "기본 내용",
                        imageURL: fullImageURLString
                    )
                }
                // 데이터가 성공적으로 로드되었음을 확인
                print("포스팅을 가져오는데 성공했어요🥰, 포스트 수: \(self?.winnerPets.count ?? 0)")
            case .failure(let error):
                print("포스팅을 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - 이미지 로드 함수
    private func loadImage(for pet: Pet, into imageView: UIImageView) {
        guard let imageURL = URL(string: pet.imageURL) else {
            print("잘못된 URL 문자열: \(pet.imageURL)")
            imageView.image = UIImage(named: "placeholder")
            return
        }

        let headers = Router.fetchPosts(query: FetchReadingPostQuery(next: nil, limit: "10", product_id: "각유저가고른1등우승자")).headersForImageRequest

        let modifier = AnyModifier { request in
            var r = request
            r.allHTTPHeaderFields = headers
            return r
        }
        
        imageView.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "placeholder"),
            options: [.requestModifier(modifier)]
        ) { result in
            switch result {
            case .success(let value):
                print("이미지 로드 성공📩: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("이미지 로드 실패📩: \(error.localizedDescription)")
            }
        }
    }
}
