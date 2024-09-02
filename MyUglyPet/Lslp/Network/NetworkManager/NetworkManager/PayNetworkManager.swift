//
//  PayNetworkManager.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//

import Foundation
import Alamofire

// MARK: - 결제
class PayNetworkManager {
    
    static let shared = PayNetworkManager()
    
    private init() {}
    
    // 영수증 검증
    func payValidateReceipt(imp_uid: String, post_id: String, completion: @escaping (Result<ReceiptValidationResponse, Error>) -> Void) {
        let query = ValidateReceiptQuery(imp_uid: imp_uid, post_id: post_id)

        print("검증에 사용되는 imp_uid: \(imp_uid), post_id: \(post_id)")
        

        let router = Router.validateReceipt(query: query)
        

        do {
            let urlRequest = try router.asURLRequest()

            if let url = urlRequest.url {
                print("서버로 보내는 URL: \(url.absoluteString)")
            }
            
            if let headers = urlRequest.allHTTPHeaderFields {
                print("요청 헤더: \(headers)")
            }
            if let token = urlRequest.value(forHTTPHeaderField: "Authorization") {
                print("액세스 토큰: \(token)")
            }
            
            AF.request(urlRequest)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: ReceiptValidationResponse.self) { response in
                    switch response.result {
                    case .success(let validationResponse):
                        print("검증 성공: \(validationResponse)")
                        completion(.success(validationResponse))
                        
                    case .failure(let error):

                        if let data = response.data {
                            if let errorJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let message = errorJson["message"] as? String {
                                print("오류 메시지: \(message)")
                                let customError = NSError(domain: "PayValidation", code: 400, userInfo: [NSLocalizedDescriptionKey: message])
                                completion(.failure(customError))
                            } else {
                                print("오류 데이터 로드 실패: \(error.localizedDescription)")
                                completion(.failure(error))
                            }
                        } else {
                            print("요청 실패: \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    }
                }
        } catch {
            print("URLRequest 생성 실패: \(error)")
            let customError = NSError(domain: "PayNetworkManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate URLRequest"])
            completion(.failure(customError))
        }
    }
    
    // 결제 내역 가져오기
    func fetchPaymentHistory(completion: @escaping (Result<[PaymentHistory], Error>) -> Void) {
        let router = Router.fetchPaymentHistory
        
        do {
            let urlRequest = try router.asURLRequest()
            AF.request(urlRequest)
                .validate()
                .responseDecodable(of: PaymentHistoryListValidationResponse.self) { response in
                    switch response.result {
                    case .success(let validationResponse):
                        // 응답에서 data 배열을 추출하여 전달
                        completion(.success(validationResponse.data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        } catch {
            completion(.failure(NSError(domain: "PayNetworkManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate URLRequest"])))
        }
    }
}

