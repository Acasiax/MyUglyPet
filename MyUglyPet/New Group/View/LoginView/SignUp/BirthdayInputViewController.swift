//
//  BirthdayInputViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/18/24.
//

import UIKit
import SnapKit

class BirthdayInputViewController: UIViewController {
    
    // UI Components
    let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 1.00
        progressView.tintColor = UIColor.lightGray
        return progressView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일을 입력해 주세요"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일은 언제든지 수정할 수 있어요"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    let yearTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0000년"
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    let monthTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "00월"
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    let dayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "00일"
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 20)
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
    
    let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음에 입력하기", for: .normal)
        button.setTitleColor(UIColor.orange, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(progressBar)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(yearTextField)
        view.addSubview(monthTextField)
        view.addSubview(dayTextField)
        view.addSubview(nextButton)
        view.addSubview(skipButton)
        
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
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalTo(view).inset(20)
        }
        
        yearTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            make.left.equalTo(view.snp.left).offset(40)
            make.width.equalTo(view.snp.width).multipliedBy(0.25)
        }
        
        monthTextField.snp.makeConstraints { make in
            make.top.equalTo(yearTextField)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).multipliedBy(0.25)
        }
        
        dayTextField.snp.makeConstraints { make in
            make.top.equalTo(yearTextField)
            make.right.equalTo(view.snp.right).offset(-40)
            make.width.equalTo(view.snp.width).multipliedBy(0.25)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(dayTextField.snp.bottom).offset(40)
            make.left.right.equalTo(view).inset(40)
            make.height.equalTo(50)
        }
        
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }
    }
}
