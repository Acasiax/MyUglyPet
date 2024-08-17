//
//  CreatePostViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/14/24.
//

import UIKit
import SnapKit
import PhotosUI

class CreatePostViewController: UIViewController, UITextViewDelegate {

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
        label.text = "/ 최소5자"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let imageContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.backgroundColor = CustomColors.softPink.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(photoAttachmentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let cameraIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "camera"))
        imageView.tintColor = .white
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
        label.text = "반려동물의 소개글을 5자 이상 남겨주시면 다른 냥멍집사에게도 도움이 됩니다."
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
    
    var selectedImageData: Data?
    
    // 선택된 이미지를 담을 배열
    var selectedImages: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.lightBeige
        reviewTextView.delegate = self
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageContainerStackView)
        
        imageContainerStackView.addArrangedSubview(sendButton)
        sendButton.addSubview(cameraIcon)
        sendButton.addSubview(photoCountLabel)
        
        view.addSubview(rewardLabel)
        view.addSubview(guidelineLabel)
        view.addSubview(reviewTextView)
        view.addSubview(characterCountLabel)
        view.addSubview(minimumTextLabel)
        view.addSubview(submitButton)
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
        
        sendButton.snp.makeConstraints { make in
            make.width.height.equalTo(90)
        }
        
        cameraIcon.snp.makeConstraints { make in
            make.center.equalTo(sendButton)
            make.width.height.equalTo(40)
        }
        
        photoCountLabel.snp.makeConstraints { make in
            make.top.equalTo(cameraIcon.snp.bottom).offset(8)
            make.centerX.equalTo(sendButton)
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
    
    @objc func photoAttachmentButtonTapped() {
        print("카메라 버튼 탭")
        AnimationZip.animateButtonPress(sendButton)

        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc func submitButtonTapped() {
        // reviewTextView의 텍스트 출력
        print("작성한 글: \(reviewTextView.text ?? "")")
        
        // 추가된 이미지 정보 출력
        print("추가한 이미지 갯수: \(selectedImages.count)")
        for (index, imageViewContainer) in selectedImages.enumerated() {
            if let imageView = imageViewContainer.subviews.first as? UIImageView, let image = imageView.image {
                print("이미지 - 인덱스 \(index + 1): 사이즈 \(image.size)")
            }
        }

        // 애니메이션 추가
        AnimationZip.animateButtonPress(submitButton)
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

// MARK: - PHPicker 사진 선택
extension CreatePostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self else { return }
                
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.addSelectedImage(image)
                    }
                }
            }
        }
    }
}
