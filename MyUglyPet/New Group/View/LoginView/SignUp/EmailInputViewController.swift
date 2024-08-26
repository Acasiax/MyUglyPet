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
    var isEmailValid: Bool = false // 이메일 중복검사 결과를 저장하는 변수
    
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
    var domains = ["gmail.com", "naver.com"]
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
        
        duplicateCheckButton.snp.makeConstraints { make in
            make.top.equalTo(domainButton.snp.bottom).offset(10)
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
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let email = getEmailAddress()

        // 이메일 유효성 검사 수행
        if isValidEmail(email) {
            duplicateCheckButton.isEnabled = true
            duplicateCheckButton.backgroundColor = UIColor.orange
        } else {
            duplicateCheckButton.isEnabled = false
            duplicateCheckButton.backgroundColor = UIColor.lightGray
        }
        resetDuplicateCheck() // 텍스트가 변경될 때 중복 검사 결과 초기화
    }

    @objc func domainButtonTapped() {
        let alertController = UIAlertController(title: "도메인 선택", message: nil, preferredStyle: .actionSheet)
        
        for domain in domains {
            let action = UIAlertAction(title: domain, style: .default) { _ in
                self.selectedDomain = domain
                self.domainButton.setTitle(domain, for: .normal)
                self.textFieldDidChange(self.usernameTextField)
                self.resetDuplicateCheck() // 도메인이 변경될 때 중복 검사 결과 초기화
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
        
        // 실제 중복 검사 API 호출
        SignUpPostNetworkManager.shared.validateEmail(email) { result in
            self.setButtonLoadingState(isLoading: false)
            switch result {
            case .success(let message):
                print("이메일 확인 성공: \(message)")
                if message == "사용 가능한 이메일입니다." {
                    self.isEmailValid = true
                    self.duplicateCheckButton.backgroundColor = UIColor.green
                    self.duplicateCheckButton.setTitle("사용 가능", for: .normal)
                    self.nextButton.isEnabled = true
                    self.nextButton.backgroundColor = UIColor.orange
                } else {
                    self.isEmailValid = false
                    self.duplicateCheckButton.backgroundColor = UIColor.red
                    self.duplicateCheckButton.setTitle("이미 사용 중", for: .normal)
                }
            case .failure(let error):
                print("이메일 확인 실패: \(error.localizedDescription)")
                self.isEmailValid = false
                self.duplicateCheckButton.backgroundColor = UIColor.red
                self.duplicateCheckButton.setTitle("오류 발생", for: .normal)
            }
        }
    }
    
    func resetDuplicateCheck() {
        // 중복 검사 초기화 (버튼 색상 및 텍스트 재설정)
        duplicateCheckButton.backgroundColor = UIColor.orange
        duplicateCheckButton.setTitle("중복검사", for: .normal)
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor.lightGray
        isEmailValid = false
    }
    
    func setButtonLoadingState(isLoading: Bool) {
        isCheckingDuplicate = isLoading
        duplicateCheckButton.isEnabled = !isLoading
        duplicateCheckButton.setTitle(isLoading ? "검사 중..." : "중복검사", for: .normal)
    }
    
    func getEmailAddress() -> String {
        let username = usernameTextField.text ?? ""
        return "\(username)@\(selectedDomain)"
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @objc func nextButtonTapped() {
        guard let nickname = nickname else {
            print("닉네임이 설정되지 않았습니다.")
            return
        }
        
        let email = getEmailAddress()
        
        if isEmailValid {
            print("닉네임: \(nickname), 이메일 \(email)은 사용 가능합니다.")
            
            // 다음 화면으로 이동
            let passwordInputVC = PasswordInputViewController()
            passwordInputVC.nickname = nickname  // 닉네임 전달
            passwordInputVC.email = email        // 이메일 전달
            navigationController?.pushViewController(passwordInputVC, animated: true)
        } else {
            print("이메일 중복 검사를 통과하지 못했습니다.")
        }
    }

}
