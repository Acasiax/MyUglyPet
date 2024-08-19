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
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            characterCountLabel.text = "\(text.count)"
            
            if text.count >= 5 {
                submitButton.isEnabled = true
                submitButton.backgroundColor = .orange
            } else {
                submitButton.isEnabled = false
                submitButton.backgroundColor = .lightGray
            }
        }
    }
    
    func addSelectedImage(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        let container = UIView()
        container.layer.cornerRadius = 10
        container.layer.borderColor = UIColor.lightGray.cgColor
        container.layer.borderWidth = 1
        container.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(container)
            make.width.height.equalTo(90)
        }
        
        let deleteButton = UIButton()
        deleteButton.setTitle("x", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .black.withAlphaComponent(0.7)
        deleteButton.layer.cornerRadius = 10
        deleteButton.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
        container.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { make in
            make.top.right.equalTo(container).inset(5)
            make.width.height.equalTo(20)
        }
        
        imageContainerStackView.addArrangedSubview(container)
        selectedImages.append(container)
        updatePhotoCountLabel()
    }
    
    @objc func deleteImage(_ sender: UIButton) {
        if let container = sender.superview, let index = selectedImages.firstIndex(of: container) {
            selectedImages[index].removeFromSuperview()
            selectedImages.remove(at: index)
            updatePhotoCountLabel()
        }
    }
    
    func updatePhotoCountLabel() {
        let count = selectedImages.count
        photoCountLabel.text = "\(count)/5"
    }
    
}
