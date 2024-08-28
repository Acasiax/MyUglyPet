//
//  PayViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/28/24.
//

import UIKit
import SnapKit

class PayViewController: UIViewController {

    // 결제하기 버튼 생성 및 설정을 클로저로 정의
    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("결제하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 버튼 추가
        view.addSubview(payButton)
        
        // SnapKit을 사용한 레이아웃 설정
        payButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        // 버튼에 액션 추가
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
    }
    
    // 버튼이 눌렸을 때 호출되는 메서드
    @objc private func payButtonTapped() {
        // 가짜 데이터로 영수증 검증을 호출합니다.
        let imp_uid = "test_imp_uid"  // 실제 데이터로 교체해야 합니다.
        let post_id = "test_post_id"  // 실제 데이터로 교체해야 합니다.
        
        validateReceipt(imp_uid: imp_uid, post_id: post_id)
        
        // 결제 내역을 조회합니다.
        fetchPaymentHistory()
        
    }
}

// MARK: - 서버 호출 관련 확장 메서드
extension PayViewController {
    func validateReceipt(imp_uid: String, post_id: String) {
        PayNetworkManager.shared.payValidateReceipt(imp_uid: imp_uid, post_id: post_id) { result in
            switch result {
            case .success(let receiptResponse):
                // 검증 성공시 처리
                print("영수증 검증 성공: \(receiptResponse)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "성공", message: "영수증 검증에 성공했습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            case .failure(let error):
                // 검증 실패시 처리
                print("영수증 검증 실패: \(error)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "실패", message: "영수증 검증에 실패했습니다. \(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

//영수증 리스트 가져오기
extension PayViewController {
    func fetchPaymentHistory() {
            PayNetworkManager.shared.fetchPaymentHistory { result in
                switch result {
                case .success(let paymentHistory):
                    // 결제 내역 조회 성공 시 처리
                    print("결제 내역 조회 성공: \(paymentHistory)")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "결제 내역", message: "결제 내역을 불러왔습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    // 결제 내역 조회 실패 시 처리
                    print("결제 내역 조회 실패: \(error)")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "실패", message: "결제 내역 조회에 실패했습니다. \(error.localizedDescription)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
}
