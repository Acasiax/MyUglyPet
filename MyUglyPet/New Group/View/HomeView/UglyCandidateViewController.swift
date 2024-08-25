//
//  UglyCandidateViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/20/24.
//

import UIKit
import SnapKit
import PhotosUI
import RxSwift
import RxCocoa
import Alamofire

class UglyCandidateViewController: UIViewController {

    let disposeBag = DisposeBag()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "후보를 등록해주세요"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.softPurple
        view.layer.cornerRadius = 20
        return view
    }()
    
    let imageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "기본냥멍3"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 75
        button.clipsToBounds = true
        return button
    }()
    
    let helloNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "사진제목"
        textField.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let subtitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "사용자이름"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.textColor = .gray
        return textField
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("후보에 등록할게요", for: .normal)
        button.backgroundColor = CustomColors.softPink
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    var selectedImageViews: [UIView] = []  // 선택된 이미지를 담은 UIView 배열

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupBindings()
    }

    func setupViews() {
        view.backgroundColor = CustomColors.lightBeige
        view.addSubview(titleLabel)
        view.addSubview(containerView)
       
        containerView.addSubview(imageButton)
        containerView.addSubview(helloNameTextField)
        containerView.addSubview(subtitleTextField)
        view.addSubview(submitButton)
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.right.equalTo(view).inset(20)
        }

        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(300)
            make.centerY.equalToSuperview().offset(-20)
        }
        
        imageButton.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }

        helloNameTextField.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }

        subtitleTextField.snp.makeConstraints { make in
            make.top.equalTo(helloNameTextField.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }

        submitButton.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
    }

    func setupBindings() {
        // 이미지 버튼 클릭 이벤트 처리
        imageButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.imageButtonTapped()
            }
            .disposed(by: disposeBag)

        // 제출 버튼 클릭 이벤트 처리
        submitButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.submitButtonTapped()
            }
            .disposed(by: disposeBag)
    }

    func imageButtonTapped() {
        print("이미지 버튼 탭!")
        AnimationZip.animateButtonPress(imageButton)

        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    func submitButtonTapped() {
        print("후보등록 버튼 클릭!")
        AnimationZip.animateButtonPress(submitButton)

        if validateFields() {
            // 텍스트 필드와 선택된 이미지의 내용을 출력
            if let photoTitle = helloNameTextField.text, let userName = subtitleTextField.text {
                print("사진 제목: \(photoTitle)")
                print("사용자 이름: \(userName)")
            }
            
            if selectedImageViews.isEmpty {
                uploadPost(withImageURLs: [])
            } else {
                uploadImagesAndPost()
            }
        }
    }

    func validateFields() -> Bool {
        var errorMessage = ""
        
        if selectedImageViews.isEmpty {
            errorMessage += "이미지를 선택해주세요.\n"
        }
        if helloNameTextField.text?.isEmpty ?? true {
            errorMessage += "사진 제목을 입력해주세요.\n"
        }
        if subtitleTextField.text?.isEmpty ?? true {
            errorMessage += "사용자 이름을 입력해주세요.\n"
        }
        
        if !errorMessage.isEmpty {
            showAlert(message: errorMessage)
            return false
        }
        
        return true
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "필수 입력 항목 누락", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func addSelectedCandidateImage(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        let imageViewContainer = UIView()
        imageViewContainer.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        selectedImageViews.append(imageViewContainer)
        imageButton.setImage(image, for: .normal)
    }

    // MARK: - 이미지 및 게시글 업로드 함수
    func uploadImagesAndPost() {
        var uploadedImageUrls: [String] = []
        let dispatchGroup = DispatchGroup()

        for (index, imageViewContainer) in selectedImageViews.enumerated() {
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
        guard let photoTitle = helloNameTextField.text, !photoTitle.isEmpty else {
            print("사진 제목이 없습니다.")
            return
        }
        let userName = subtitleTextField.text ?? ""
        let productId: String? = "못난이후보등록"

        print("업로드할 이미지 URL: \(imageUrls)")

        PostNetworkManager.shared.createPost(
            title: photoTitle,
            content: "",
            content1: userName,
            productId: productId,
            fileURLs: imageUrls
        ) { result in
            switch result {
            case .success:
                print("게시글 업로드 성공")
                self.helloNameTextField.text = ""
                self.subtitleTextField.text = ""
                self.selectedImageViews.removeAll()
                self.imageButton.setImage(UIImage(named: "기본냥멍3"), for: .normal)
            case .failure(let error):
                print("게시글 업로드 실패: \(error.localizedDescription)")
            }
        }
    }
}


// MARK: - PHPicker 사진 선택
extension UglyCandidateViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self else { return }
                
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.addSelectedCandidateImage(image)
                    }
                }
            }
        }
    }
}

