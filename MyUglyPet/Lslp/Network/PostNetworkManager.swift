//
//  PostNetworkManager.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/19/24.
//


import UIKit
import Alamofire


// MARK: - 팔로우 기능
class FollowPostNetworkManager {
    
    static let shared = FollowPostNetworkManager()
    
    private init() {}
    
    func followUser(userID: String, completion: @escaping (Result<FollowResponse, Error>) -> Void) {
        let router = Router.follow(userID: userID)
        
        AF.request(router.asURLRequest)
            .validate()
            .responseDecodable(of: FollowResponse.self) { response in
                switch response.result {
                case .success(let followResponse):
                    completion(.success(followResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}





import UIKit
import Alamofire

class PostNetworkManager {
    
    static let shared = PostNetworkManager()
    
    private init() {}

    //MARK: - 포스트 삭제
       func deletePost(postID: String, completion: @escaping (Result<Void, Error>) -> Void) {
           let request = Router.deletePost(postID: postID).asURLRequest
           print("👻포스트네트워크매니져의딜리트함수: \(postID)")
           AF.request(request)
                       .validate(statusCode: 200..<300) // 성공적인 응답 코드를 검증
                       .response { response in           // responseData 대신 response로 변경
                           if let error = response.error {
                               print("포스트 삭제 실패: \(error)")
                               completion(.failure(error))
                           } else {
                               print("포스트 삭제 성공")
                               completion(.success(()))
                           }
                       }
               
       }

    
    
    //MARK: - 댓글 작성/등록
    func postComment(toPostWithID postID: String, content: String, completion: @escaping (Result<Void, Error>) -> Void) {
            let query = CommentQuery(content: content) // CommentQuery 생성
            let request = Router.postComment(postID: postID, query: query).asURLRequest
            
      
        print("Request URL: \(request.url?.absoluteString ?? "No URL")")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        print("Request Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "No Body")")

        
        
        AF.request(request)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    // 응답 데이터를 확인해보세요
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Response JSON String: \(jsonString)")
                    } else {
                        print("Response data could not be converted to a string.")
                    }

                    do {
                        let result = try JSONDecoder().decode(CommentResponse.self, from: data)
                        completion(.success(()))
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Request failed with error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }

        }
    

    
    
    
    //MARK: - 포스트 조희
    func fetchPosts(query: FetchReadingPostQuery, completion: @escaping (Result<[PostsModel], Error>) -> Void) {
        let request = Router.fetchPosts(query: query).asURLRequest
        
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



    //MARK: - 해쉬태그 포스트 조회
    func fetchHashtagPosts(query: FetchHashtagReadingPostQuery, completion: @escaping (Result<[PostsModel], Error>) -> Void) {
           let request = Router.fetchHashtagPosts(query: query).asURLRequest
           
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
    
    
    
    
    //MARK: - 이미지 업로드🔥
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
                    
                    let result = try JSONDecoder().decode(PostImageModel.self, from: data)
                    print("🩵이미지 업로드 성공: \(result.files ?? [])")  // 성공 메시지 출력
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
        content1: String?,
        productId: String?,
        fileURLs: [String],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let parameters: [String: Any] = [
            "title": title ?? "",
            "content": content ?? "",
            "content1": content1 ?? "",
            "product_id": productId ?? "",
            "files": fileURLs
        ]
        
        let request = Router.createPost(parameters: parameters).asURLRequest
        
        AF.request(request)
            .response { response in
                switch response.result {
                case .success:
                    if response.response?.statusCode == 200 {
                        print("숨막혀")
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




import UIKit
import Alamofire

//MARK: - 우승자 이미지 포스팅 업로드🔥
class WinnerPostNetworkManager {
    
    static let shared = WinnerPostNetworkManager()
    
    private init() {}
    
    //MARK: - 이미지 업로드🔥
    func uploadPostImage(query: ImageUploadQuery, originalURL: String, completion: @escaping (Result<[String], Error>) -> Void) {
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
                    
                    let result = try JSONDecoder().decode(PostImageModel.self, from: data)
                    print("🩵🩵 이미지 업로드 성공: \(result.files)")  // 성공 메시지 출력
                    
                    // 기존 URL을 유지하여 completion으로 전달
                    completion(.success([originalURL]))
                    
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
        content1: String?,
        productId: String?,
        fileURLs: [String],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let parameters: [String: Any] = [
            "title": title ?? "",
            "content": content ?? "",
            "content1": content1 ?? "",
            "product_id": productId ?? "",
            "files": fileURLs
        ]
        
        let request = Router.createPost(parameters: parameters).asURLRequest
        
        AF.request(request)
            .response { response in
                switch response.result {
                case .success:
                    if response.response?.statusCode == 200 {
                        print("숨막혀")
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


