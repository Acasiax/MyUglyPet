//
//  SignUpPostNetworkManager.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//

import Foundation
import Alamofire

class SignUpPostNetworkManager {
    
    static let shared = SignUpPostNetworkManager()
    
    private init() {}
    
    // MARK: - 회원가입 기능
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
    
    
    // MARK: - 이메일 중복 확인 기능
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

