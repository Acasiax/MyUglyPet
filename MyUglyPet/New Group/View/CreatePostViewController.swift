//
//  CreatePostViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/14/24.
//

import UIKit
import SnapKit

class CreatePostViewController: UIViewController, UITextViewDelegate {

    let submitButton = UIButton(type: .system)
    let characterCountLabel = UILabel()
    let minimumTextLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
 
        let photoAttachmentButton = UIButton()
        photoAttachmentButton.layer.borderColor = UIColor.lightGray.cgColor
        photoAttachmentButton.layer.borderWidth = 1
        photoAttachmentButton.layer.cornerRadius = 10
        photoAttachmentButton.addTarget(self, action: #selector(photoAttachmentButtonTapped), for: .touchUpInside)
        
        let cameraIcon = UIImageView(image: UIImage(systemName: "camera"))
        cameraIcon.tintColor = .lightGray
        
        let photoCountLabel = UILabel()
        photoCountLabel.text = "0/5"
        photoCountLabel.font = UIFont.systemFont(ofSize: 12)
        photoCountLabel.textColor = .lightGray
        
        view.addSubview(photoAttachmentButton)
        photoAttachmentButton.addSubview(cameraIcon)
        photoAttachmentButton.addSubview(photoCountLabel)
        

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
        
        
        let rewardLabel = UILabel()
        rewardLabel.text = "사진 첨부 시 150M → 500M 지급"
        rewardLabel.font = UIFont.systemFont(ofSize: 14)
        rewardLabel.textColor = .orange
        
        view.addSubview(rewardLabel)
        rewardLabel.snp.makeConstraints { make in
            make.top.equalTo(photoAttachmentButton.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
        }
        
        
        let guidelineLabel = UILabel()
        guidelineLabel.text = "반려동물의 소개글을 10자 이상 남겨주시면 다른 냥멍집사에게도 도움이 됩니다."
        guidelineLabel.font = UIFont.systemFont(ofSize: 14)
        guidelineLabel.textColor = .gray
        guidelineLabel.numberOfLines = 0
        
        view.addSubview(guidelineLabel)
        guidelineLabel.snp.makeConstraints { make in
            make.top.equalTo(rewardLabel.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        
        // TextView for Review
        let reviewTextView = UITextView()
        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.cornerRadius = 5
        reviewTextView.font = UIFont.systemFont(ofSize: 16)
        reviewTextView.delegate = self
        
        view.addSubview(reviewTextView)
        reviewTextView.snp.makeConstraints { make in
            make.top.equalTo(guidelineLabel.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(150)
        }
        
        // Character Count Label
        characterCountLabel.text = "0"
        characterCountLabel.font = UIFont.systemFont(ofSize: 12)
        characterCountLabel.textColor = .lightGray
        
        minimumTextLabel.text = "/ 최소10자"
        minimumTextLabel.font = UIFont.systemFont(ofSize: 12)
        minimumTextLabel.textColor = .lightGray
        
        view.addSubview(characterCountLabel)
        view.addSubview(minimumTextLabel)
        
        characterCountLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewTextView.snp.bottom).offset(8)
            make.trailing.equalTo(reviewTextView.snp.trailing).offset(-50)
        }
        
        minimumTextLabel.snp.makeConstraints { make in
            make.centerY.equalTo(characterCountLabel)
            make.leading.equalTo(characterCountLabel.snp.trailing)
        }
        
        // Submit Button
        submitButton.setTitle("작성 완료", for: .normal)
        submitButton.backgroundColor = UIColor.lightGray
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 5
        submitButton.isEnabled = false
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        view.addSubview(submitButton)
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
