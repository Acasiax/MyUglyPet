//
//  CreatePostViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/14/24.
//

import UIKit
import SnapKit
import Alamofire
import PhotosUI


struct PostImageModel: Decodable{
    let files: [String]
}




struct PostsModel: Decodable {
    let title: String?        // 게시글 제목 (선택적)
    let content: String?      // 게시글 본문 (선택적)
    let content1: String?     // 추가 콘텐츠 필드 (선택적)
    let content2: String?     // 추가 콘텐츠 필드 (선택적)
    let content3: String?     // 추가 콘텐츠 필드 (선택적)
    let content4: String?     // 추가 콘텐츠 필드 (선택적)
    let content5: String?     // 추가 콘텐츠 필드 (선택적)
    let productId: String?    // 제품 ID (선택적)
    let files: [String]?      // 이미지 파일 경로 목록 (선택적)
    
    enum CodingKeys: String, CodingKey {
        case title
        case content
        case content1
        case content2
        case content3
        case content4
        case content5
        case productId = "product_id"
        case files
    }
}


final class CreatePostViewController: UIViewController, UITextViewDelegate {

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
    
    let photoAttachmentButton: UIButton = {
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
        guard let text = reviewTextView.text, !text.isEmpty else {
            print("게시글 내용이 없습니다.")
            return
        }

        // 애니메이션 추가
        AnimationZip.animateButtonPress(submitButton)
        
        // 이미지 업로드가 필요한 경우
        if selectedImages.isEmpty {
            // 이미지가 없는 경우 게시글만 업로드
            uploadPost(withImageURLs: [])
        } else {
            // 이미지가 있는 경우 이미지부터 업로드
            uploadImages { [weak self] result in
                switch result {
                case .success(let imageUrls):
                    self?.uploadPost(withImageURLs: imageUrls)
                case .failure(let error):
                    print("이미지 업로드 실패: \(error.localizedDescription)")
                }
            }
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
    
    func uploadImages(completion: @escaping (Result<[String], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var uploadedImageUrls: [String] = []
        var uploadError: Error?
        
        for imageViewContainer in selectedImages {
            guard let imageView = imageViewContainer.subviews.first as? UIImageView,
                  let image = imageView.image,
                  let imageData = image.jpegData(compressionQuality: 0.8) else { continue }
            
            dispatchGroup.enter()
            
            PostNetworkManager.shared.uploadPostImage(imageData: imageData) { result in
                switch result {
                case .success(let urls):
                    uploadedImageUrls.append(contentsOf: urls)
                case .failure(let error):
                    uploadError = error
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if let error = uploadError {
                completion(.failure(error))
            } else {
                completion(.success(uploadedImageUrls))
            }
        }
    }

    
    func uploadPost(withImageURLs imageUrls: [String]) {
        let title = "게시글 제목"
        let content = reviewTextView.text
        let content1: String? = nil
        let content2: String? = nil
        let content3: String? = nil
        let content4: String? = nil
        let content5: String? = nil
        let productId: String? = nil

        print("업로드할 이미지 URL: \(imageUrls)")

        PostNetworkManager.shared.createPost(title: title, content: content, content1: content1, content2: content2, content3: content3, content4: content4, content5: content5, productId: productId, fileURLs: imageUrls) { result in
            switch result {
            case .success:
                print("게시글 업로드 성공")
            case .failure(let error):
                print("게시글 업로드 실패: \(error.localizedDescription)")
            }
        }
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


class PostNetworkManager {
    
    static let shared = PostNetworkManager()
    
    private init() {}
    
    //MARK: - 이미지 업로드
    func uploadPostImage(imageData: Data, completion: @escaping (Result<[String], Error>) -> Void) {
        let request = Router.uploadPostImage(imageData: imageData).asURLRequest
        
        AF.request(request)
            .responseDecodable(of: PostImageModel.self) { response in
                switch response.result {
                case .success(let result):
                    completion(.success(result.files))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    
    //MARK: - 게시글 업로드
    func createPost(title: String?, content: String?, content1: String?, content2: String?, content3: String?, content4: String?, content5: String?, productId: String?, fileURLs: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        
        let parameters: [String: Any] = [
            "title": title ?? "",
            "content": content ?? "",
            "content1": content1 ?? "",
            "content2": content2 ?? "",
            "content3": content3 ?? "",
            "content4": content4 ?? "",
            "content5": content5 ?? "",
            "product_id": productId ?? "",
            "files": fileURLs
        ]
        
        let request = Router.createPost(parameters: parameters).asURLRequest
        
        AF.request(request)
            .response { response in
                switch response.result {
                case .success:
                    if response.response?.statusCode == 200 {
                        completion(.success(()))
                    } else {
                        let error = NSError(domain: "", code: response.response?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "포스트 작성 실패"])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    
    
}
