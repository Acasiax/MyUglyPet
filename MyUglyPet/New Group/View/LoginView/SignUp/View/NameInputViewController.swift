//
//  NameInputViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class NameInputViewController: UIViewController {
    
    let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.20
        progressView.tintColor = UIColor.lightGray
        return progressView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요!\n당신의 이름을 알려주시겠어요?"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해 주세요"
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 20)
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
    
    private let viewModel = NameInputViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(progressBar)
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
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
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.right.equalTo(view).inset(40)
            make.height.equalTo(50)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(40)
            make.left.right.equalTo(view).inset(40)
            make.height.equalTo(50)
        }
    }
    
    func bindViewModel() {
        let input = NameInputViewModel.Input(
            nameText: nameTextField.rx.text.orEmpty.asObservable(),
            nextButtonTap: nextButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isNextButtonEnabled
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isNextButtonEnabled
            .map { $0 ? CustomColors.softPink : UIColor.lightGray }
            .drive(nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.navigateToNextScreen
            .subscribe(onNext: { [unowned self] nickname in
                print("입력한 닉네임: \(nickname)")
                let emailInputVC = EmailInputViewController()
                emailInputVC.nickname = nickname
                self.navigationController?.pushViewController(emailInputVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

