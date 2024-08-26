//
//  EmailInputViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/18/24.
//

import UIKit
import SnapKit

class EmailInputViewController: UIViewController {
    
    var nickname: String?
    

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
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일"
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
    
    let atLabel: UILabel = {
        let label = UILabel()
        label.text = "@"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let domainButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("gmail.com", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(domainButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let customDomainTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "도메인을 입력해 주세요"
        textField.borderStyle = .none
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.isHidden = true
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
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var isCheckingDuplicate = false
    var domains = ["gmail.com", "naver.com", "직접 입력"]
    var selectedDomain = "gmail.com"
    
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
        view.addSubview(usernameTextField)
        view.addSubview(atLabel)
        view.addSubview(domainButton)
        view.addSubview(customDomainTextField)
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
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.equalTo(view).inset(40)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        atLabel.snp.makeConstraints { make in
            make.centerY.equalTo(usernameTextField)
            make.left.equalTo(usernameTextField.snp.right).offset(10)
        }
        
        domainButton.snp.makeConstraints { make in
            make.centerY.equalTo(usernameTextField)
            make.left.equalTo(atLabel.snp.right).offset(10)
            make.right.equalTo(view).inset(40)
        }
        
        customDomainTextField.snp.makeConstraints { make in
            make.top.equalTo(domainButton.snp.bottom).offset(10)
            make.left.equalTo(atLabel.snp.right).offset(10)
            make.right.equalTo(view).inset(40)
            make.height.equalTo(50)
        }
        
        duplicateCheckButton.snp.makeConstraints { make in
            make.top.equalTo(customDomainTextField.snp.bottom).offset(10)
            make.left.equalTo(view).inset(40)
            make.right.equalTo(view).inset(40)
            make.height.equalTo(40)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(duplicateCheckButton.snp.bottom).offset(20)
            make.left.right.equalTo(view).inset(40)
            make.height.equalTo(50)
        }
        
        
    }
    
    func configureTextField() {
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        customDomainTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    
    @objc func nextButtonTapped() {
        print("다음버튼탭")
           let passwordInputVC = PasswordInputViewController()
           navigationController?.pushViewController(passwordInputVC, animated: true)
       }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let email = getEmailAddress()
        if isValidEmail(email) {
            duplicateCheckButton.isEnabled = true
            duplicateCheckButton.backgroundColor = UIColor.orange
        } else {
            duplicateCheckButton.isEnabled = false
            duplicateCheckButton.backgroundColor = UIColor.lightGray
        }
    }
    
    @objc func domainButtonTapped() {
        let alertController = UIAlertController(title: "도메인 선택", message: nil, preferredStyle: .actionSheet)
        
        for domain in domains {
            let action = UIAlertAction(title: domain, style: .default) { _ in
                self.selectedDomain = domain
                self.domainButton.setTitle(domain, for: .normal)
                self.customDomainTextField.isHidden = (domain != "직접 입력")
                self.textFieldDidChange(self.usernameTextField)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func duplicateCheckButtonTapped() {
        let email = getEmailAddress()
        guard isValidEmail(email) else { return }
        
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
    
    func getEmailAddress() -> String {
        let username = usernameTextField.text ?? ""
        let domain = selectedDomain == "직접 입력" ? customDomainTextField.text ?? "" : selectedDomain
        return "\(username)@\(domain)"
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
 
}

extension EmailInputViewController {
    
    func checkEmailDuplicate(email: String) -> Bool {
        // 여기에 중복 검사 로직을 구현
        // 예시로 무작위로 중복 여부 결정
        return Bool.random()
    }
    
    
}
