//
//  CreatePostViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/14/24.
//

import UIKit
import SnapKit

class CreatePostViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    // 요소를 클로저 형태로 정의
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("작성 완료", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    let minimumTextLabel: UILabel = {
        let label = UILabel()
        label.text = "/ 최소10자"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    let photoAttachmentButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(photoAttachmentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let cameraIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "camera"))
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    let photoCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/5"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    let rewardLabel: UILabel = {
        let label = UILabel()
        label.text = "사진 첨부 시 150M → 500M 지급"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .orange
        return label
    }()
    
    let guidelineLabel: UILabel = {
        let label = UILabel()
        label.text = "반려동물의 소개글을 10자 이상 남겨주시면 다른 냥멍집사에게도 도움이 됩니다."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
//    let reviewTextView: UITextField = {
//        let textField = UITextField()
//        textField.layer.borderColor = UIColor.lightGray.cgColor
//        textField.layer.borderWidth = 1
//        textField.layer.cornerRadius = 5
//        textField.font = UIFont.systemFont(ofSize: 16)
//        textField.placeholder = "여기에 내용을 입력하세요..."
//        textField.contentVerticalAlignment = .top // 커서를 상단에 맞춤
//        return textField
//    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        reviewTextView.delegate = self
        addSubviews()
        setupConstraints()
    }
    
    // 모든 addSubview를 여기에 모아둠
    func addSubviews() {
        view.addSubview(photoAttachmentButton)
        photoAttachmentButton.addSubview(cameraIcon)
        photoAttachmentButton.addSubview(photoCountLabel)
        
        view.addSubview(rewardLabel)
        view.addSubview(guidelineLabel)
        view.addSubview(reviewTextView)
        view.addSubview(characterCountLabel)
        view.addSubview(minimumTextLabel)
        view.addSubview(submitButton)
    }
    
    // 오토레이아웃 설정을 여기에 모아둠
    func setupConstraints() {
        photoAttachmentButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view).offset(20)
            make.width.height.equalTo(90)
        }
        
        cameraIcon.snp.makeConstraints { make in
            make.center.equalTo(photoAttachmentButton)
            make.width.height.equalTo(40)
        }
        
        photoCountLabel.snp.makeConstraints { make in
            make.top.equalTo(cameraIcon.snp.bottom).offset(8)
            make.centerX.equalTo(photoAttachmentButton)
        }
        
        rewardLabel.snp.makeConstraints { make in
            make.top.equalTo(photoAttachmentButton.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
        }
        
        guidelineLabel.snp.makeConstraints { make in
            make.top.equalTo(rewardLabel.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        
        reviewTextView.snp.makeConstraints { make in
            make.top.equalTo(guidelineLabel.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(150)
        }
        
        characterCountLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewTextView.snp.bottom).offset(8)
            make.trailing.equalTo(reviewTextView.snp.trailing).offset(-50)
        }
        
        minimumTextLabel.snp.makeConstraints { make in
            make.centerY.equalTo(characterCountLabel)
            make.leading.equalTo(characterCountLabel.snp.trailing)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(characterCountLabel.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(50)
        }
    }
    
    @objc func photoAttachmentButtonTapped() {
        print("Photo attachment button tapped")
    }
    
    @objc func submitButtonTapped() {
        print("Submit button tapped")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            // 글자 수에 따라 characterCountLabel 업데이트
            characterCountLabel.text = "\(text.count)"
            
            // 글자 수가 10 이상이면 버튼 활성화
            if text.count >= 10 {
                submitButton.isEnabled = true
                submitButton.backgroundColor = .orange
            } else {
                submitButton.isEnabled = false
                submitButton.backgroundColor = .lightGray
            }
        }
    }
}
