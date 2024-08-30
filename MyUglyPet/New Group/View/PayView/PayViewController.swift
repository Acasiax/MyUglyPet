//
//  PayViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/28/24.
//

//9/1(일) lslp 마무리,  9/2(월) 리드미 가이드 + 제출 ppt 템플릿
//9/3(화) 팀빌딩(각자앱 + 트러블 슈팅)
//9/4(수)
//9/5(목) lslp 팀, 랜덤으로 발표자 결정
// 9/8(일) 서버 종료
import UIKit
import SnapKit

class PayViewController: UIViewController {

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
        setupUI()
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        
    }
    
    func setupUI() {
        view.addSubview(payButton)
        payButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
    }
    
    
    @objc private func payButtonTapped() {
        AnimationZip.animateButtonPress(payButton)
        let paymentVC = PaymentViewController()
        paymentVC.modalPresentationStyle = .fullScreen
        present(paymentVC, animated: true, completion: nil)
    }
}



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
            make.edges.equalToSuperview() // 전체 화면을 WebView로 채움
        }
        
        initiatePayment()
    }
    
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
    
    //"post_id": "66d170dfdfc656014224bf35",
    //    "product_id": "개발자돈주기",
    //    "title": "10원 기부하기",
    //    "content": "10원 기부할게요",
    
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
