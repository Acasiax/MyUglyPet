//
//  PasswordInputViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordInputViewController: UIViewController {
    
    var nickname: String?
    var email: String?
    
    private let viewModel = PasswordInputViewModel()
    private let disposeBag = DisposeBag()
    
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
        textField.isSecureTextEntry = true
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
        button.setTitle("비번 보이기", for: .normal)
        button.setTitleColor(.orange, for: .normal)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.nickname = nickname
        viewModel.email = email
        
        bindViewModel()
        
        print("이메일뷰에서 전달 받은 닉네임: \(nickname ?? ""), 이메일: \(email ?? "")")
    }
    
    private func setupUI() {
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
    
    private func bindViewModel() {
        let input = PasswordInputViewModel.Input(
            passwordText: passwordTextField.rx.text.orEmpty.asObservable(),
            togglePasswordVisibility: togglePasswordVisibilityButton.rx.tap.asObservable(),
            nextButtonTap: nextButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isNextButtonEnabled
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isNextButtonEnabled
            .map { $0 ? UIColor.orange : UIColor.lightGray }
            .drive(nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.isPasswordVisible
            .drive(onNext: { [weak self] isVisible in
                self?.passwordTextField.isSecureTextEntry = !isVisible
                self?.togglePasswordVisibilityButton.setTitle(isVisible ? "비번 가리기" : "비번 보이기", for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.showSuccessMessage
            .drive(onNext: { [weak self] message in
                self?.showAlert(message: message)
                let welcomeVC = WelcomeViewController()
                self?.navigationController?.pushViewController(welcomeVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showErrorMessage
            .drive(onNext: { [weak self] message in
                self?.showAlert(message: message)
            })
            .disposed(by: disposeBag)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            // 확인 버튼이 눌렸을 때 WelcomeViewController로 이동
            let welcomeVC = WelcomeViewController()
            self?.navigationController?.pushViewController(welcomeVC, animated: true)
        }
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }

}




