//
//  PostNetworkManager.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/19/24.
//


import UIKit
import Alamofire



struct RegistrationResponse: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
}


struct ProfileModel: Decodable {
    let id: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email, nick
    }
}

struct ServerResponse: Decodable {
    let message: String
}

class SignUpPostNetworkManager {
    
    static let shared = SignUpPostNetworkManager()
    
    private init() {}
    
    
    // MARK: - 회원가입 기능 추가
    static func registerUser(email: String, password: String, nick: String, phoneNum: String?, birthDay: String?, completion: @escaping (Result<String, Error>) -> Void) {
        
        // 전달된 매개변수들을 출력
        print("registerUser - email: \(email), password: \(password), nick: \(nick), phoneNum: \(phoneNum ?? ""), birthDay: \(birthDay ?? "")")
        
        do {
            let query = RegistrationResponse(email: email, password: password, nick: nick, phoneNum: nil, birthDay: nil)
            
            // JSON 데이터로 인코딩 후 출력
            let jsonData = try JSONEncoder().encode(query)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("전송할 JSON 데이터: \(jsonString)")
            }
            
            let request = try Router.register(query: query).asURLRequest()
            
            AF.request(request).responseDecodable(of: ProfileModel.self) { response in
                switch response.result {
                case .success(let success):
                    print("서버 응답 메시지: \(success)")
                    completion(.success("회원가입 성공: \(success)"))
                case .failure(let failure):
                    print("서버 응답 실패: \(failure)")
                    completion(.failure(failure))
                }
            }
        } catch {
            print("error \(error)")
            completion(.failure(error))
        }
    }
    
    
    // MARK: - 이메일 중복 확인 기능 추가
    func validateEmail(_ email: String, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let router = Router.validateEmail(email: email)
            let request = try router.asURLRequest()
            
            AF.request(request)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: EmailValidationResponse.self) { response in
                    switch response.result {
                    case .success(let validationResponse):
                        completion(.success(validationResponse.message))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        } catch {
            completion(.failure(error))
        }
    }
}


// MARK: - 팔로우 기능
class FollowPostNetworkManager {

    static let shared = FollowPostNetworkManager()
    
    private init() {}
    
    // 내 프로필 조회
       func fetchMyProfile(completion: @escaping (Result<MyProfileResponse, Error>) -> Void) {
           let router = Router.fetchMyProfile

           do {
               let request = try router.asURLRequest()
               
               AF.request(request).responseDecodable(of: MyProfileResponse.self) { response in
                   switch response.result {
                   case .success(let profileResponse):
                       completion(.success(profileResponse))
                   case .failure(let error):
                       completion(.failure(error))
                   }
               }
           } catch {
               completion(.failure(error))
           }
       }
    
    
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
    
    // MARK: - 언팔로우 기능 추가
    func unfollowUser(userID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let router = Router.unfollow(userID: userID)
        
        AF.request(router.asURLRequest)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(())) // 성공 시 Void 반환
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
    //MARK: - 게시글 좋아요 설정 및 취소
    func likePost(postID: String, likeStatus: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        let query = LikePostQuery(like_status: likeStatus)
        let request = Router.likePost(postID: postID, query: query).asURLRequest
        
        AF.request(request)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        // 서버에서 반환된 데이터를 확인 (예: 좋아요 상태 반환 여부)
                        let result = try JSONDecoder().decode(LikePostQuery.self, from: data)
                        completion(.success(result.like_status))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    
    
    //MARK: - 특정 유저별 포스터 조회
        func fetchUserPosts(userID: String, query: FetchReadingPostQuery, completion: @escaping (Result<[PostsModel], Error>) -> Void) {
            let request = Router.fetchUserPosts(userID: userID, query: query).asURLRequest
            
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

    
    //MARK: - 댓글 삭제
    func deleteComment(postID: String, commentID: String, completion: @escaping (Bool, Error?) -> Void) {
        do {
            let router = try Router.deleteComment(postID: postID, commentID: commentID).asURLRequest()
            
            AF.request(router)
                .response { response in  // responseData 대신 response로 변경하여 비어있는 응답도 처리 가능하게 함
                    if let error = response.error {
                        print("서버 요청 실패: \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        if let data = response.data, data.isEmpty {
                            print("서버 응답이 비어 있습니다. 하지만 성공으로 간주합니다.")
                            completion(true, nil)  // 비어있는 응답도 성공으로 간주
                        } else {
                            print("서버 응답 데이터: \(response.data ?? Data())")
                            completion(true, nil)
                        }
                    }
                }
        } catch {
            completion(false, error)
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
        content3: String?, //위도
        content4: String?, //경도
        productId: String?,
        fileURLs: [String],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let parameters: [String: Any] = [
            "title": title ?? "",
            "content": content ?? "",
            "content1": content1 ?? "",
            "content3": content3 ?? "위도값없음",
            "content4": content4 ?? "경도값없음",
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


