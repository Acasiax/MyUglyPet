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
}
