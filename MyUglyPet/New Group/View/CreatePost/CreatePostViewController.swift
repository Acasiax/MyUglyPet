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

    private let disposeBag = DisposeBag()
    private let viewModel = CreatePostViewModel()

    // UI 요소들을 구조체를 통해 초기화
    let submitButton = NewPostUI.submitButtonUI()
    let characterCountLabel = NewPostUI.characterCountLabelUI()
    let minimumTextLabel = NewPostUI.minimumTextLabelUI()
    let scrollView = NewPostUI.scrollViewUI()
    let imageContainerStackView = NewPostUI.imageContainerStackViewUI()
    let photoAttachmentButton = NewPostUI.photoAttachmentButtonUI()
    let cameraIcon = NewPostUI.cameraIconUI()
    let photoCountLabel = NewPostUI.photoCountLabelUI()
    let rewardLabel = NewPostUI.rewardLabelUI()
    let guidelineLabel = NewPostUI.guidelineLabelUI()
    let titleTextField = NewPostUI.titleTextFieldUI()
    let reviewTextView = NewPostUI.reviewTextViewUI()
    let activityIndicator = NewPostUI.activityIndicatorUI()

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
        let input = CreatePostViewModel.Input(
            reviewText: reviewTextView.rx.text.orEmpty.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.characterCount
            .drive(characterCountLabel.rx.text)
            .disposed(by: disposeBag)

        output.isSubmitButtonEnabled
            .drive(onNext: { [weak self] isEnabled in
                self?.submitButton.isEnabled = isEnabled
                self?.submitButton.backgroundColor = isEnabled ? .orange : .lightGray
            })
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

    func photoAttachmentButtonTapped() {
        print("카메라 버튼 탭")
        AnimationZip.animateButtonPress(photoAttachmentButton)

        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func submitButtonTapped() {
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
            print("게시글 제목이 비어있습니다.")
            return
        }
        let content = reviewTextView.text ?? ""
        let productId: String? = "allFeed"

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
