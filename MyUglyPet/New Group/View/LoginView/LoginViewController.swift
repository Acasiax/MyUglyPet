//
//  LoginViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/18/24.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "반가워요!\n로그인 해주세요"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "아이디"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = UIColor(red: 0.5, green: 0.6, blue: 1.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(UIColor(red: 0.2, green: 0.4, blue: 1.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    func setupUI() {
        view.backgroundColor = CustomColors.softBlue
        
        view.addSubview(welcomeLabel)
        view.addSubview(idTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.left.right.equalTo(view).inset(20)
        }
        
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(40)
            make.left.right.equalTo(view).inset(40)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(20)
            make.left.right.equalTo(view).inset(40)
            make.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.left.right.equalTo(view).inset(40)
            make.height.equalTo(50)
        }
        
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }
    }
    
    func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
    }
    
    @objc func loginButtonTapped() {
        handleLogin()
    }

    @objc func signupButtonTapped() {
        print("회원가입버튼탭")
        let nameInputViewController = NameInputViewController()
        navigationController?.pushViewController(nameInputViewController, animated: true)
    }
    
    func handleLogin() {
        print("로그인버튼탭")
        
        let enteredUsername = idTextField.text ?? ""
        let enteredPassword = passwordTextField.text ?? ""
        
        print("입력된 아이디: \(enteredUsername)")
        print("입력된 비밀번호: \(enteredPassword)")
        
        MyLoginNetworkManager.shared.createLogin(email: enteredUsername, password: enteredPassword) { success in
               if success {
                   let mainTabBarController = TabBarControllerFactory.createMainTabBarController()
                   mainTabBarController.modalPresentationStyle = .fullScreen
                   mainTabBarController.modalTransitionStyle = .crossDissolve
                   self.present(mainTabBarController, animated: true, completion: nil)
               } else {
                   print("로그인 실패")
                   // 여기서 로그인 실패에 대한 UI를 업데이트하거나 알림을 표시할 수 있습니다.
               }
        }
    }
}

