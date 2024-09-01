//
//  MyLoginNetworkManager.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/18/24.
//

import Foundation
import Alamofire

class MyLoginNetworkManager {
    
    static let shared = MyLoginNetworkManager()
    
    private init() {}
    
    // 로그인 메서드
    func createLogin(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let query = LoginQuery(email: email, password: password)
        
        do {
            let request = try Router.login(query: query).asURLRequest()
            
            AF.request(request)
              .responseDecodable(of: LoginModel.self) { response in
                  
                switch response.result {
                case .success(let success):
                    print("로그인 성공:", success)
                    UserDefaultsManager.shared.token = success.access
                    UserDefaultsManager.shared.refreshToken = success.refresh
                    UserDefaultsManager.shared.id = success.id
                    completion(true) // 로그인 성공
                    
                case .failure(let failure):
                    print("로그인 실패:", failure)
                    completion(false) // 로그인 실패를 알림
                }
            }
        } catch {
            print("로그인 요청 생성 중 오류 발생:", error)
            completion(false) // 요청 생성 실패를 알림
        }
    }
    
    
    
    func refreshToken() {
        do {
            // 요청 생성
            let request = try Router.refresh.asURLRequest()
            
            // 요청 전송
            AF.request(request)
              .responseDecodable(of: RefreshModel.self) { response in
                  
                if response.response?.statusCode == 418 {
                    // 리프레시 토큰 만료 처리
                    print("리프레시 토큰이 만료되었습니다.")
                    // 필요한 추가 처리 (예: 로그인 화면으로 전환)
                } else {
                    switch response.result {
                    case .success(let success):
                        print("토큰 갱신 성공:", success)
                        
                        // 새로운 Access Token 저장
                        UserDefaultsManager.shared.token = success.accessToken
                        
                        // 갱신된 토큰으로 프로필 정보 요청
                       // self.fetchProfile()
                      //  FollowPostNetworkManager.shared.fetchMyProfile()
                    case .failure(let failure):
                        print("토큰 갱신 실패:", failure)
                        // 실패 시 추가 처리 (예: 사용자에게 오류 알림)
                    }
                }
            }

        } catch {
            print("토큰 갱신 요청 생성 중 오류 발생:", error)
        }
    }
   
}
