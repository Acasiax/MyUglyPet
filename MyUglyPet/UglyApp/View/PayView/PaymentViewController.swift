//
//  PaymentViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/31/24.
//

//"post_id": "66d170dfdfc656014224bf35",
//    "product_id": "개발자돈주기",
//    "title": "10원 기부하기",
//    "content": "10원 기부할게요",

import UIKit
import WebKit
import iamport_ios

class PaymentViewController: UIViewController {
    private let wkWebView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        return webView
    }()
    
    private let userCode = "imp57573124"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(wkWebView)
        wkWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        initiatePayment()
    }
    
    private func initiatePayment() {
        let merchantUID = "ios_\(Date().timeIntervalSince1970)"  // 고유한 결제 ID 생성 새싹 키 안넣었는데 이미 고유해서 잘 되나봄?
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
        
        Iamport.shared.paymentWebView(
            webViewMode: wkWebView,
            userCode: userCode,
            payment: payment) { [weak self] iamportResponse in
            print(String(describing: iamportResponse))
            
            if let response = iamportResponse, response.success == true {
                if let impUid = response.imp_uid {
                    self?.handlePaymentSuccess(impUid: impUid)
                }
            } else {
                print("결제 오류가 발생했습니다.")
            }
        }
    }
    
    private func handlePaymentSuccess(impUid: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "성공", message: "결제가 성공적으로 완료되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        validateReceipt(imp_uid: impUid, post_id: "66d17ed51691d4013e5523af")
        fetchPaymentHistory()
    }
    
    
    private func validateReceipt(imp_uid: String, post_id: String) {
        
        print("검증에 사용되는 imp_uid: \(imp_uid), post_id: \(post_id)")
        
        PayNetworkManager.shared.payValidateReceipt(imp_uid: imp_uid, post_id: post_id) { result in
            
            switch result {
            case .success(let receiptResponse):
                print("영수증 검증 성공: \(receiptResponse)")
                
            case .failure(let error):
                print("영수증 검증 실패: \(error)")
            }
        }
    }
    
    private func fetchPaymentHistory() {
        PayNetworkManager.shared.fetchPaymentHistory { result in
            switch result {
            case .success(let paymentHistory):
                print("결제 내역 조회 성공: \(paymentHistory)")
                
            case .failure(let error):
                print("결제 내역 조회 실패: \(error)")
            }
        }
    }
}
