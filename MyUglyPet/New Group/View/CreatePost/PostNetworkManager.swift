//
//  PostNetworkManager.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/19/24.
//

import UIKit
import Alamofire

class PostNetworkManager {
    
    static let shared = PostNetworkManager()
    
    private init() {}
    
    //MARK: - 포스트 조희
    func fetchPosts(nextCursor: String?, limit: Int?, completion: @escaping (Result<[Post], Error>) -> Void) {
        let request = Router.fetchPosts(nextCursor: nextCursor, limit: limit).asURLRequest
        
        AF.request(request)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let result = try JSONDecoder().decode(PostsResponse.self, from: data)
                        completion(.success(result.data))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    
    
    
    
    //MARK: - 이미지 업로드
    func uploadPostImage(query: ImageUploadQuery, completion: @escaping (Result<[String], Error>) -> Void) {
        let router = Router.uploadPostImage(imageData: query.files)
        let urlRequest = router.asURLRequest
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(query.files, withName: "files", fileName: "postImage.jpeg", mimeType: "image/jpeg")
        }, with: urlRequest)
        .response { response in
            if let data = response.data {
                let jsonString = String(data: data, encoding: .utf8)
                print("서버 응답 데이터: \(jsonString ?? "데이터 없음")")
            }
            
            switch response.result {
            case .success(let data):
                do {
                    guard let data = data else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "데이터가 없습니다."])))
                        return
                    }
                    
                    let result = try JSONDecoder().decode(PostsModel.self, from: data)
                    print("이미지 업로드 성공: \(result.files ?? [])")  // 성공 메시지 출력
                    completion(.success(result.files ?? []))
                } catch {
                    print("디코딩 실패: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("이미지 업로드 실패: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }


    //MARK: - 게시글 업로드
    func createPost(
        title: String?,
        content: String?,
        productId: String?,
        fileURLs: [String],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let parameters: [String: Any] = [
            "title": title ?? "",
            "content": content ?? "",
            "product_id": productId ?? "",
            "files": fileURLs
        ]
        
        let request = Router.createPost(parameters: parameters).asURLRequest
        
        AF.request(request)
            .response { response in
                switch response.result {
                case .success:
                    if response.response?.statusCode == 200 {
                        completion(.success(()))
                    } else {
                        let error = NSError(domain: "", code: response.response?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "포스트 작성 실패"])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}