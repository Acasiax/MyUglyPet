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
        
        view.addSubview(progressBar)
        view.addSubview(titleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(togglePasswordVisibilityButton)
        view.addSubview(nextButton)
        
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
        passwordTextField.isSecureTextEntry.toggle()
        if passwordTextField.isSecureTextEntry {
            togglePasswordVisibilityButton.setTitle("비번 보이기", for: .normal)
        } else {
            togglePasswordVisibilityButton.setTitle("비번 가리기", for: .normal)
        }
    }
    
    @objc func nextButtonTapped() {
        guard let email = email, let nickname = nickname, let password = passwordTextField.text else {
            showAlert(message: "필수 정보가 누락되었습니다.")
            return
        }
        
        fetchSignup(email: email, nickname: nickname, password: password)
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



    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        print("회원가입에러: \(message)")
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
}


extension PasswordInputViewController {
    
    func fetchSignup(email: String, nickname: String, password: String) {
        
        // 전달된 매개변수들을 출력
               print("fetchSignup - email: \(email), nickname: \(nickname), password: \(password)")
        
        SignUpPostNetworkManager.registerUser(email: email, password: password, nick: nickname, phoneNum: "11", birthDay: "2000") { result in
            switch result {
                
            case .success(let successMessage):
                DispatchQueue.main.async {
                    self.showAlert(message: successMessage)
                    let welcomeVC = WelcomeViewController()
                    self.navigationController?.pushViewController(welcomeVC, animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: "회원가입 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
