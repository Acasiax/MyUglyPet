//
//  CreatePostViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Alamofire
import PhotosUI

final class CreatePostViewController: UIViewController, UITextViewDelegate {

    private let disposeBag = DisposeBag()  // DisposeBag 초기화
    
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("작성 완료", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.isEnabled = false
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
    
    let photoAttachmentButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.backgroundColor = CustomColors.softPink.withAlphaComponent(0.5)
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
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "게시글 제목을 입력하세요(필수*)"
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .white
        return textField
    }()
    
    let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        return indicator
    }()

    var selectedImageData: Data?
    var selectedImages: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.lightBeige
        reviewTextView.delegate = self
        addSubviews()
        setupConstraints()
        activityIndicator.center = view.center
        
        setupBindings()
    }
    
    private func setupBindings() {
        // 텍스트 뷰의 입력을 관찰하고 캐릭터 수 업데이트
        reviewTextView.rx.text.orEmpty
            .map { "\($0.count)" }
            .bind(to: characterCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 텍스트 뷰의 입력을 관찰하여 버튼 활성화 상태 업데이트
        reviewTextView.rx.text.orEmpty
            .map { $0.count >= 5 }
            .bind(with: self) { owner, isEnabled in
                owner.submitButton.isEnabled = isEnabled
                owner.submitButton.backgroundColor = isEnabled ? .orange : .lightGray
            }
            .disposed(by: disposeBag)
        
        // 사진 첨부 버튼 클릭 이벤트 처리
        photoAttachmentButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.photoAttachmentButtonTapped()
            }
            .disposed(by: disposeBag)
        
        // 작성 완료 버튼 클릭 이벤트 처리
        submitButton.rx.tap
            .bind(with: self) { owner,_  in
                owner.submitButtonTapped()
            }
            .disposed(by: disposeBag)
    }

    
    @objc func photoAttachmentButtonTapped() {
        print("카메라 버튼 탭")
        AnimationZip.animateButtonPress(photoAttachmentButton)

        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc func submitButtonTapped() {
        print(selectedImages.count)
        print(selectedImages.debugDescription)
        guard let text = reviewTextView.text, !text.isEmpty else {
            print("게시글 내용이 없습니다.")
            return
        }

        AnimationZip.animateButtonPress(submitButton)
        
        if selectedImages.isEmpty {
            uploadPost(withImageURLs: [])
        } else {
            uploadImagesAndPost()
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
        container.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { make in
            make.top.right.equalTo(container).inset(5)
            make.width.height.equalTo(20)
        }
        
        imageContainerStackView.addArrangedSubview(container)
        selectedImages.append(container)
        updatePhotoCountLabel()
        
        // RxSwift를 사용하여 버튼 이벤트 처리
        deleteButton.rx.tap
            .bind(with: self) { owner, _ in
                if let index = owner.selectedImages.firstIndex(of: container) {
                    owner.selectedImages[index].removeFromSuperview()
                    owner.selectedImages.remove(at: index)
                    owner.updatePhotoCountLabel()
                }
            }
            .disposed(by: disposeBag)
    }

    
    func updatePhotoCountLabel() {
        let count = selectedImages.count
        photoCountLabel.text = "\(count)/5"
    }
}


// MARK: - 이미지, 게시글 업로드 함수
extension CreatePostViewController {
    
    func uploadImagesAndPost() {
        var uploadedImageUrls: [String] = []
        let dispatchGroup = DispatchGroup()

        for (index, imageViewContainer) in selectedImages.enumerated() {
            print("처리 중인 이미지 인덱스: \(index)")
            
            guard let imageView = imageViewContainer.subviews.first as? UIImageView,
                  let image = imageView.image,
                  let imageData = image.jpegData(compressionQuality: 0.8) else {
                print("이미지 데이터 생성 실패")
                continue
            }
            
            print("이미지 데이터 크기: \(imageData.count) bytes")
            
            dispatchGroup.enter()
            
            let imageUploadQuery = ImageUploadQuery(files: imageData)
            
            PostNetworkManager.shared.uploadPostImage(query: imageUploadQuery) { result in
                switch result {
                case .success(let imageUrls):
                    if imageUrls.isEmpty {
                        print("서버에서 빈 이미지 URL 배열을 반환했습니다.")
                    } else {
                        print("이미지 업로드 성공!!: \(imageUrls)")
                        uploadedImageUrls.append(contentsOf: imageUrls)
                    }
                case .failure(let error):
                    print("이미지 업로드 실패: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            if uploadedImageUrls.isEmpty {
                print("모든 이미지 업로드 실패")
                let alert = UIAlertController(title: "오류", message: "모든 이미지 업로드에 실패했습니다.", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
            } else {
                print("모든 이미지 업로드 성공, 업로드된 이미지 URLs: \(uploadedImageUrls)")
                self.uploadPost(withImageURLs: uploadedImageUrls)
            }
        }
    }

    func uploadPost(withImageURLs imageUrls: [String]) {
        activityIndicator.startAnimating()
        
        guard let title = titleTextField.text, !title.isEmpty else {
                print("게시글 제목: \(title)")
                return
            }
        let content = reviewTextView.text ?? ""
       // let productId: String? = nil
        let productId: String? = "allFeed" //🌟

        print("업로드할 이미지 URL: \(imageUrls)")

        PostNetworkManager.shared.createPost(
            title: title,
            content: content,
            content1: "",
            productId: productId,
            fileURLs: imageUrls
        ) { result in
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success:
                print("게시글 업로드 성공")
                self.reviewTextView.text = ""
                self.selectedImages.removeAll()
                self.updatePhotoCountLabel()
                self.updateSubmitButtonState()
                
                let readingAllPostHomeVC = AllPostHomeViewController()
                self.navigationController?.pushViewController(readingAllPostHomeVC, animated: true)
            case .failure(let error):
                print("게시글 업로드 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func updateSubmitButtonState() {
        let isTextValid = reviewTextView.text.count >= 5
        submitButton.isEnabled = isTextValid
        submitButton.backgroundColor = isTextValid ? .orange : .lightGray
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

