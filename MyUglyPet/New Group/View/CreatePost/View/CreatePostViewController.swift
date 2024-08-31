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

    // MARK: - 상태 관리 변수
    var selectedImageData: Data?
    var selectedImages: [UIView] = []

    // 위도와 경도를 저장할 변수
       var latitude: String? //위도
       var longitude: String? //경도
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCurrentLocation()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.lightBeige
        reviewTextView.delegate = self
        addSubviews()
        setupConstraints()
        activityIndicator.center = view.center
        
        setupBindings()
    }
    
    // MARK: - 데이터 바인딩 설정
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
                self?.submitButton.backgroundColor = isEnabled ? CustomColors.softPink : .lightGray
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

    // MARK: - 게시글 제출
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

    // MARK: - 텍스트뷰 변경 처리
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            characterCountLabel.text = "\(text.count)"
            
            if text.count >= 5 {
                submitButton.isEnabled = true
                submitButton.backgroundColor = CustomColors.softPink
            } else {
                submitButton.isEnabled = false
                submitButton.backgroundColor = .lightGray
            }
        }
    }

    // MARK: - 사진 수 업데이트
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
    
    // MARK: - 사진 첨부 버튼 클릭 처리
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
    
    // MARK: - 선택한 사진 추가
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
}
