//
//  CreatePostUI.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit

struct NewPostUI {
    
    static func submitButtonUI() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("작성 완료", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        return button
    }
    
    static func characterCountLabelUI() -> UILabel {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }
    
    static func minimumTextLabelUI() -> UILabel {
        let label = UILabel()
        label.text = "/ 최소5자"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }
    
    static func scrollViewUI() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }
    
    static func imageContainerStackViewUI() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }
    
    static func photoAttachmentButtonUI() -> UIButton {
        let button = UIButton()
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.systemPink.withAlphaComponent(0.5)
        return button
    }
    
    static func cameraIconUI() -> UIImageView {
        let imageView = UIImageView(image: UIImage(systemName: "camera"))
        imageView.tintColor = .white
        return imageView
    }
    
    static func photoCountLabelUI() -> UILabel {
        let label = UILabel()
        label.text = "0/5"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }
    
    static func rewardLabelUI() -> UILabel {
        let label = UILabel()
        label.text = "사진 첨부 시 150M → 500M 지급"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .orange
        return label
    }
    
    static func guidelineLabelUI() -> UILabel {
        let label = UILabel()
        label.text = "반려동물의 소개글을 5자 이상 남겨주시면 다른 냥멍집사에게도 도움이 됩니다."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }
    
    static func titleTextFieldUI() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "게시글 제목을 입력하세요(필수*)"
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .white
        return textField
    }
    
    static func reviewTextViewUI() -> UITextView {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }
    
    static func activityIndicatorUI() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        return indicator
    }
}

