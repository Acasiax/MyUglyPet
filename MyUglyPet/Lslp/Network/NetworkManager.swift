//
//  NetworkManager.swift
//  SeSAC5LSLPPractice
//
//  Created by jack on 7/25/24.
//

import Foundation
import Alamofire

/*
 구조체 싱글턴 vs 클래스 싱글턴 => 구조체 클래스 차이. 참조 값.
 */
struct NetworkManager {
    
    private init() { }
    
    static func createLogin(email: String, password: String) {

        do {
            let query = LoginQuery(email: email, password: password)
            
            let request = try Router.login(query: query).asURLRequest()
            
            AF.request(request)
              .responseDecodable(of: LoginModel.self) { response in
                  
                switch response.result {
                case .success(let success):
                    
                     print("OK", success)
                    UserDefaultsManager.shared.token = success.access
                    UserDefaultsManager.shared.refreshToken = success.refresh
                    // 성공적으로 로그인이 되었을 때에만 화면 전환!
    //                let vc = ProfileViewController()
    //                self.setRootViewController(vc)
                    
                case .failure(let failure):
                    print("Fail", failure)
                }
            }
        } catch {
            print(error)
        }
    }

// 1. Router Enum 왜만듬?
// 2. TargetType Protocol 굳이 왜 필요함?
// 3. URLRequestConvertible이 뭔디?
// 4. asURLRequest가 하고 있는건 뭐야?
 //*/
    static func fetchProfile() {

        do {
            let request = try Router.fetchProfile.asURLRequest()
            
            AF.request(request)
            .responseDecodable(of: ProfileModel.self) { response in
                
                if response.response?.statusCode == 419 {
                    self.refreshToken()
                } else {
                    switch response.result {
                    case .success(let success):
                        print("OK", success)
//                        self.profileView.emailLabel.text = success.email
//                        self.profileView.userNameLabel.text = success.nick
                    case .failure(let failure):
                        print("Fail", failure)
                    }
                }
            }
        } catch {
            print(error, "URLRequestConvertible 에서 asURLRequest 로 요청 만드는거 실패!!")
        }

    }
    
    static func editProfile() {
        
        do {
            let request = try Router.editProfile.asURLRequest()
            
            AF.request(request)
            .responseDecodable(of: ProfileModel.self) { response in
                
                if response.response?.statusCode == 419 {
                    self.refreshToken()
                } else {
                    switch response.result {
                    case .success(let success):
                        print("OK", success)
                        
                        self.fetchProfile()
                        
                    case .failure(let failure):
                        print("Fail", failure)
                    }
                }
            }

        } catch {
            print(error)
        }
    }
    
    static func refreshToken() {

        do {
            let request = try Router.refresh.asURLRequest()
            
            AF.request(request)
            .responseDecodable(of: RefreshModel.self) { response in
                 
                if response.response?.statusCode == 418 {
                    //리프레시 토큰 만료
                } else {
                    switch response.result {
                    case .success(let success):
                        print("OK", success)
                        
                        UserDefaultsManager.shared.token = success.accessToken
                        
                        self.fetchProfile()
                        
                    case .failure(let failure):
                        print("Fail", failure)
                    }
                }
            }

        } catch {
            print(error)
        }
    }
}

//하나의 인스턴스에서 관리
//final class NetworkManager {
//    
//    static let shared = NetworkManager()
//    
//    private init() { }
//    
//    func callRequest() { }
//    
//}















