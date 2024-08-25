//
//  BaseCreatePost.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/18/24.
//

import UIKit
import SnapKit
import PhotosUI

extension CreatePostViewController {

    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageContainerStackView)
        
        imageContainerStackView.addArrangedSubview(photoAttachmentButton)
        photoAttachmentButton.addSubview(cameraIcon)
        photoAttachmentButton.addSubview(photoCountLabel)
        
        view.addSubview(rewardLabel)
        view.addSubview(guidelineLabel)
        view.addSubview(titleTextField)
        view.addSubview(reviewTextView)
        view.addSubview(characterCountLabel)
        view.addSubview(minimumTextLabel)
        view.addSubview(submitButton)
        view.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(90)
        }
        
        imageContainerStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        
        photoAttachmentButton.snp.makeConstraints { make in
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
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
        }
        
        guidelineLabel.snp.makeConstraints { make in
            make.top.equalTo(rewardLabel.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(guidelineLabel.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        
        reviewTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
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

   
}

