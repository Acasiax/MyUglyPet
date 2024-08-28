//
//  PayViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/28/24.
//

import UIKit
import SnapKit
import WebKit  // WebView를 사용하기 위해 추가
import iamport_ios // Iamport SDK를 사용하기 위해 추가

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
    
    // WebView 생성
    lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // WebView 추가
        view.addSubview(wkWebView)
        wkWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 전체 화면을 WebView로 채움
        }

        // 결제 버튼 추가
        view.addSubview(payButton)
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
        initiatePayment()
    }
    
    // 결제 요청을 시작하는 메서드
    private func initiatePayment() {
        let merchantUID = "ios_\(Date().timeIntervalSince1970)"  // 고유한 결제 ID 생성
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: merchantUID,
            amount: "10"  // 결제 금액을 적절하게 설정
        ).then {
            $0.pay_method = PayMethod.card.rawValue
            $0.name = "잭님의 사투리 교실"
            $0.buyer_name = "이윤지"
            $0.app_scheme = "sesac"
        }
        
        // 포트원 SDK로 결제 요청
        Iamport.shared.paymentWebView(
            webViewMode: wkWebView,
            userCode: "imp57573124",
            payment: payment) { [weak self] iamportResponse in
            print(String(describing: iamportResponse))
            
            if let response = iamportResponse, response.success == true {
                if let impUid = response.imp_uid {
                    self?.handlePaymentSuccess(impUid: impUid)
                }
            } else {
                // iamportResponse가 nil이거나 실패한 경우 기본적인 오류 처리
//                let errorResponse = iamportResponse ?? IamportResponse
//                self?.handlePaymentFailure(errorResponse)
                
                print("결제오류가 났어용")
            }
        }
    }

    // 결제 성공 처리
    private func handlePaymentSuccess(impUid: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "성공", message: "결제가 성공적으로 완료되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        // 영수증 검증 및 결제 내역 조회
        validateReceipt(imp_uid: impUid, post_id: "test_post_id")
        fetchPaymentHistory()
    }

    // 결제 실패 처리
    private func handlePaymentFailure(_ response: IamportResponse) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "실패", message: "결제에 실패했습니다. \(response.error_msg ?? "알 수 없는 오류")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
    
    //결제 리스트 조회
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
