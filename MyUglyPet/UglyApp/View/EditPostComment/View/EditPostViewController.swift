//
//  EditPostViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EditPostViewController: UIViewController {
    
    var postTitle: String?
    var postContent: String?
    var onUpdate: ((String, String) -> Void)?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "내용"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let contentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "내용을 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel = EditPostViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupViews()
        setupConstraints()
        
        titleTextField.text = postTitle
        contentTextField.text = postContent
        
        bindUI()
    }
    
    private func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(titleTextField)
        containerView.addSubview(contentLabel)
        containerView.addSubview(contentTextField)
        containerView.addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(500)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(20)
            make.leading.equalTo(containerView).offset(20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(containerView).offset(20)
            make.trailing.equalTo(containerView).offset(-20)
            make.height.equalTo(40)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.leading.equalTo(containerView).offset(20)
        }
        
        contentTextField.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.leading.equalTo(containerView).offset(20)
            make.trailing.equalTo(containerView).offset(-20)
            make.height.equalTo(40)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextField.snp.bottom).offset(30)
            make.centerX.equalTo(containerView)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
    }
    
    private func bindUI() {
        let input = EditPostViewModel.Input(
            confirmTap: confirmButton.rx.tap.asObservable(),
            titleText: titleTextField.rx.text.asObservable(),
            contentText: contentTextField.rx.text.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isConfirmEnabled
            .drive(confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.updatedData
            .bind(with: self) { owner, data in
                owner.onUpdate?(data.0, data.1)
                owner.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}
