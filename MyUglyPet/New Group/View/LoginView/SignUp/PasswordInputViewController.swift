//
//  PasswordInputViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/18/24.
//

import UIKit
import SnapKit

class PasswordInputViewController: UIViewController {
    
    var nickname: String?
    var email: String?
    
    let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.66
        progressView.tintColor = UIColor.lightGray
        return progressView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요!\n비밀번호를 입력해 주세요"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해 주세요"
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 20)
        // 초기에는 비밀번호가 보이도록 설정
        textField.isSecureTextEntry = false
        let bottomLine = UIView()
        bottomLine.backgroundColor = .lightGray
        textField.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalTo(textField)
            make.bottom.equalTo(textField.snp.bottom).offset(-8)
        }
        return textField
    }()
    
    // "비번 가리기" 버튼 추가
    let togglePasswordVisibilityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("비번 가리기", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTextField()
        
        print("이메일뷰에서 전달 받은 닉네임: \(nickname ?? ""), 이메일: \(email ?? "")")
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(progressBar)
        view.addSubview(titleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(togglePasswordVisibilityButton)
        view.addSubview(nextButton)
        
        // Set up SnapKit constraints
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalTo(view).inset(40)
            make.height.equalTo(2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(30)
            make.left.right.equalTo(view).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.right.equalTo(view).inset(40)
            make.height.equalTo(50)
        }
        
        togglePasswordVisibilityButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.right.equalTo(passwordTextField.snp.right)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(togglePasswordVisibilityButton.snp.bottom).offset(30)
            make.left.right.equalTo(view).inset(40)
            make.height.equalTo(50)
        }
    }
    
    func configureTextField() {
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func togglePasswordVisibility() {
        // 현재 설정된 isSecureTextEntry 속성을 반전시킵니다.
        passwordTextField.isSecureTextEntry.toggle()
        
        // 토글된 상태에 따라 버튼의 제목을 변경합니다.
        if passwordTextField.isSecureTextEntry {
            togglePasswordVisibilityButton.setTitle("비번 보이기", for: .normal)
        } else {
            togglePasswordVisibilityButton.setTitle("비번 가리기", for: .normal)
        }
    }
    
    @objc func nextButtonTapped() {
        // 닉네임과 이메일, 비밀번호를 출력합니다.
        print("닉네임: \(nickname ?? "닉네임 없음"), 이메일: \(email ?? "이메일 없음"), 비밀번호: \(passwordTextField.text ?? "비밀번호 없음")")
        
        let welcomeVC = WelcomeViewController()
        navigationController?.pushViewController(welcomeVC, animated: true)
    }

    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            nextButton.backgroundColor = UIColor.orange
            nextButton.isEnabled = true
        } else {
            nextButton.backgroundColor = UIColor.lightGray
            nextButton.isEnabled = false
        }
    }
}
