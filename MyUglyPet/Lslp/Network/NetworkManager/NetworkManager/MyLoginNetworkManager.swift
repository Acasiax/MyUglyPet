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
                    completion(true)
                    
                case .failure(let failure):
                    print("로그인 실패:", failure)
                    completion(false)
                }
            }
        } catch {
            print("로그인 요청 생성 중 오류 발생:", error)
            completion(false)
        }
    }
    
    // 리프레시 토큰 갱신 메서드
        func refreshToken(completion: @escaping (Bool) -> Void) {
            do {
                let request = try Router.refresh.asURLRequest()
                
                AF.request(request)
                    .responseDecodable(of: RefreshModel.self) { response in
                        
                        // 응답 로그 출력
                        if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                            print("서버 응답: \(json)")
                        }
                        
                        if response.response?.statusCode == 418 {
                            // 리프레시 토큰 만료 처리
                            print("리프레시 토큰이 만료되었습니다.")
                            completion(false)
                        } else if response.response?.statusCode == 403 || response.response?.statusCode == 401 {
                    
                            print("권한 문제로 토큰 갱신 실패.")
                            completion(false)
                        } else {
                            switch response.result {
                            case .success(let success):
                                print("토큰 갱신 성공:", success)
                                UserDefaultsManager.shared.token = success.accessToken
                                completion(true)
                                
                            case .failure(let failure):
                                print("토큰 갱신 실패:", failure)
                                // 서버가 예상하지 못한 응답을 보낸 경우
                                if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                                    print("디코딩 실패. 서버 응답: \(json)")
                                }
                                completion(false)
                            }
                        }
                    }
                
            } catch {
                print("토큰 갱신 요청 생성 중 오류 발생:", error)
                completion(false)
            }
        }
 
}
