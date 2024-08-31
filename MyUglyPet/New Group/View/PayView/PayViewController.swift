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



