//
//  WelcomeViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/18/24.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "기본냥멍5") // 실제 이미지 이름으로 교체
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let completionLabel: UILabel = {
        let label = UILabel()
        label.text = "가입 완료!"
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        label.textColor = UIColor.green // 적절한 색상으로 설정
        label.textAlignment = .center
        return label
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "이윤지님, 환영해요!" // 실제 사용자 이름으로 대체
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//                   self.navigateToMainTabBarController()
//               }
        
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(iconImageView)
        view.addSubview(completionLabel)
        view.addSubview(welcomeLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-50)
            make.width.height.equalTo(100) // 적절한 크기로 조정
        }
        
        completionLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.left.right.equalTo(view).inset(20)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(completionLabel.snp.bottom).offset(10)
            make.left.right.equalTo(view).inset(20)
        }
    }
}
