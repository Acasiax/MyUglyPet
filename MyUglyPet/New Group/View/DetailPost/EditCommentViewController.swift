//
//  EditCommentViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/31/24.
//

import UIKit
import SnapKit

final class EditCommentViewController: UIViewController {
    
    var commentContent: String?
    var onUpdate: ((String) -> Void)?  // 수정된 클로저 프로퍼티
    
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
        label.text = "댓글 수정"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "댓글을 입력하세요"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupViews()
        setupConstraints()
        
        // 텍스트 필드에 기존 댓글 내용을 설정
        commentTextField.text = commentContent
        
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(commentTextField)
        containerView.addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(20)
            make.leading.equalTo(containerView).offset(20)
        }
        
        commentTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(containerView).offset(20)
            make.trailing.equalTo(containerView).offset(-20)
            make.height.equalTo(40)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(commentTextField.snp.bottom).offset(30)
            make.centerX.equalTo(containerView)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
    }
    
    @objc private func didTapConfirmButton() {
        guard let newComment = commentTextField.text else { return }
        
        // 클로저를 통해 수정된 데이터를 전달
        onUpdate?(newComment)
        
        dismiss(animated: true, completion: nil)
    }
}
