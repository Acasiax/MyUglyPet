//
//  PasswordInputViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/18/24.
//

import UIKit
import SnapKit

class PasswordInputViewController: UIViewController {
    
    // UI Components
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
        configureTextField()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(progressBar)
        view.addSubview(titleLabel)
        view.addSubview(passwordTextField)
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
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.left.right.equalTo(view).inset(40)
            make.height.equalTo(50)
        }
    }
    
    func configureTextField() {
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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

