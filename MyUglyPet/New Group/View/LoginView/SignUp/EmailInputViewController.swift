//
//  EmailInputViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/18/24.
//

import UIKit
import SnapKit

class EmailInputViewController: UIViewController {
    
    // UI Components
    let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.40
        progressView.tintColor = UIColor.lightGray
        return progressView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요!\n당신의 이메일을 입력해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력해 주세요"
        textField.borderStyle = .none
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
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
    
    let duplicateCheckButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중복검사", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.addTarget(self, action: #selector(duplicateCheckButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()
    
    var isCheckingDuplicate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTextField()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(progressBar)
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(duplicateCheckButton)
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
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.equalTo(view).inset(40)
            make.right.equalTo(view).inset(150)
            make.height.equalTo(50)
        }
        
        duplicateCheckButton.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextField)
            make.left.equalTo(emailTextField.snp.right).offset(10)
            make.right.equalTo(view).inset(40)
            make.height.equalTo(40)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(40)
            make.left.right.equalTo(view).inset(40)
            make.height.equalTo(50)
        }
    }
    
    func configureTextField() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, isValidEmail(text) {
            duplicateCheckButton.isEnabled = true
            duplicateCheckButton.backgroundColor = UIColor.orange
        } else {
            duplicateCheckButton.isEnabled = false
            duplicateCheckButton.backgroundColor = UIColor.lightGray
        }
    }
    
    @objc func duplicateCheckButtonTapped() {
        guard let email = emailTextField.text, isValidEmail(email) else { return }
        
        // 중복 검사 요청 상태 표시
        setButtonLoadingState(isLoading: true)
        
        // 여기서 중복 검사 API 호출, 아래는 예시를 위한 딜레이 처리
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.setButtonLoadingState(isLoading: false)
            
            // 중복 검사 결과 처리
            let isDuplicate = self.checkEmailDuplicate(email: email) // 이 부분은 실제 API 결과에 따라 변경
            if isDuplicate {
                self.duplicateCheckButton.backgroundColor = UIColor.red
                self.duplicateCheckButton.setTitle("이미 사용 중", for: .normal)
            } else {
                self.duplicateCheckButton.backgroundColor = UIColor.green
                self.duplicateCheckButton.setTitle("사용 가능", for: .normal)
                self.nextButton.isEnabled = true
                self.nextButton.backgroundColor = UIColor.orange
            }
        }
    }
    
    func setButtonLoadingState(isLoading: Bool) {
        isCheckingDuplicate = isLoading
        duplicateCheckButton.isEnabled = !isLoading
        duplicateCheckButton.setTitle(isLoading ? "검사 중..." : "중복검사", for: .normal)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func checkEmailDuplicate(email: String) -> Bool {
        // 여기에 중복 검사 로직을 구현
        // 예시로 무작위로 중복 여부 결정
        return Bool.random()
    }
}

