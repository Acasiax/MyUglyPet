//
//  FollowPostNetworkManager.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//


import Foundation
import Alamofire

// MARK: - 팔로우 기능
class FollowPostNetworkManager {
    
    static let shared = FollowPostNetworkManager()
    
    private init() {}
    
    // 다른 유저 프로필 조회
    func fetchUserProfile(userID: String, completion: @escaping (Result<MyProfileResponse, Error>) -> Void) {
        let router = Router.fetchUserProfile(userID: userID)
        
        do {
            let request = try router.asURLRequest() // 메서드 호출로 수정
            
            AF.request(request).responseDecodable(of: MyProfileResponse.self) { response in
                if response.response?.statusCode == 419 {
                    MyLoginNetworkManager.shared.refreshToken { success in
                        if success {
                            self.fetchUserProfile(userID: userID, completion: completion)
                        } else {
                            completion(.failure(NSError(domain: "FollowPostNetworkManager", code: 419, userInfo: [NSLocalizedDescriptionKey: "토큰 갱신 실패"])))
                        }
                    }
                } else {
                    switch response.result {
                    case .success(let profileResponse):
                        completion(.success(profileResponse))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    // 내 프로필 조회
    func fetchMyProfile(completion: @escaping (Result<MyProfileResponse, Error>) -> Void) {
        let router = Router.fetchMyProfile
        
        do {
            let request = try router.asURLRequest() // 메서드 호출로 수정
            
            AF.request(request).responseDecodable(of: MyProfileResponse.self) { response in
                if response.response?.statusCode == 419 {
                    MyLoginNetworkManager.shared.refreshToken { success in
                        if success {
                            self.fetchMyProfile(completion: completion)
                        } else {
                            completion(.failure(NSError(domain: "FollowPostNetworkManager", code: 419, userInfo: [NSLocalizedDescriptionKey: "토큰 갱신 실패"])))
                        }
                    }
                } else {
                    switch response.result {
                    case .success(let profileResponse):
                        completion(.success(profileResponse))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func followUser(userID: String, completion: @escaping (Result<FollowResponse, Error>) -> Void) {
        let router = Router.follow(userID: userID)
        
        do {
            let request = try router.asURLRequest() // 메서드 호출로 수정
            
            AF.request(request)
                .validate()
                .responseDecodable(of: FollowResponse.self) { response in
                    if response.response?.statusCode == 419 {
                        MyLoginNetworkManager.shared.refreshToken { success in
                            if success {
                                self.followUser(userID: userID, completion: completion)
                            } else {
                                completion(.failure(NSError(domain: "FollowPostNetworkManager", code: 419, userInfo: [NSLocalizedDescriptionKey: "토큰 갱신 실패"])))
                            }
                        }
                    } else {
                        switch response.result {
                        case .success(let followResponse):
                            completion(.success(followResponse))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
        } catch {
            completion(.failure(NSError(domain: "FollowPostNetworkManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "URLRequest 생성 실패"])))
        }
    }
    
    // MARK: - 언팔로우 기능 추가
    func unfollowUser(userID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let router = Router.unfollow(userID: userID)
        
        do {
            let request = try router.asURLRequest() // 메서드 호출로 수정
            
            AF.request(request)
                .validate()
                .response { response in
                    if response.response?.statusCode == 419 {
                        MyLoginNetworkManager.shared.refreshToken { success in
                            if success {
                                self.unfollowUser(userID: userID, completion: completion)
                            } else {
                                completion(.failure(NSError(domain: "FollowPostNetworkManager", code: 419, userInfo: [NSLocalizedDescriptionKey: "토큰 갱신 실패"])))
                            }
                        }
                    } else {
                        switch response.result {
                        case .success:
                            completion(.success(())) // 성공 시 Void 반환
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
        } catch {
            completion(.failure(NSError(domain: "FollowPostNetworkManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "URLRequest 생성 실패"])))
        }
    }
}

