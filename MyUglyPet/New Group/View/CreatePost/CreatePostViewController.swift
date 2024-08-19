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

//MARK: -  포스트 조회
//struct Post: Codable {
//    let postId: String
//    let title: String
//    let content: String
//    // 필요한 다른 필드들 추가
//}

struct PostsResponse: Codable {
    let data: [PostsModel]
    let nextCursor: String?
}


//MARK: - 포스트 이미지 업로드

struct PostImageModel: Decodable {
    let files: [String]
}


struct ImageUploadQuery: Encodable {
    let files: Data
}

struct PostQuery: Encodable {
    let title: String
    let content: String
    let content1: String
    let product_id: String
    let files: [String]
}

//struct PostsModel: Codable {
//    let title: String?        // 게시글 제목 (선택적)
//    let content: String?      // 게시글 본문 (선택적)
//    let content1: String?     // 추가 콘텐츠 필드 (선택적)
//    let content2: String?     // 추가 콘텐츠 필드 (선택적)
//    let content3: String?     // 추가 콘텐츠 필드 (선택적)
//    let content4: String?     // 추가 콘텐츠 필드 (선택적)
//    let content5: String?     // 추가 콘텐츠 필드 (선택적)
//    let productId: String?    // 제품 ID (선택적)
//    let files: [String]?      // 이미지 파일 경로 목록 (선택적)
//    
//    enum CodingKeys: String, CodingKey {
//        case title
//        case content
//        case content1
//        case content2
//        case content3
//        case content4
//        case content5
//        case productId = "product_id"
//        case files
//    }
//}
struct PostsModel: Codable {
    let postId: String            // 게시글 ID
    let productId: String?        // 제품 ID (선택적)
    let title: String?            // 게시글 제목 (선택적)
    let content: String?          // 게시글 본문 (선택적)
    let content1: String?         // 추가 콘텐츠 필드 (선택적)
    let content2: String?         // 추가 콘텐츠 필드 (선택적)
    let content3: String?         // 추가 콘텐츠 필드 (선택적)
    let content4: String?         // 추가 콘텐츠 필드 (선택적)
    let content5: String?         // 추가 콘텐츠 필드 (선택적)
    let createdAt: String         // 생성 날짜
    let creator: Creator          // 작성자 정보
    let files: [String]?          // 이미지 파일 경로 목록 (선택적)
    let likes: [String]?          // 좋아요 목록 (선택적)
    let likes2: [String]?         // 추가 좋아요 목록 (선택적)
    let hashTags: [String]?       // 해시태그 목록 (선택적)
    let comments: [Comment]?      // 댓글 목록 (선택적)
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case title
        case content
        case content1
        case content2
        case content3
        case content4
        case content5
        case createdAt
        case creator
        case files
        case likes
        case likes2
        case hashTags = "hashTags"
        case comments
    }
}

struct Creator: Codable {
    let userId: String             // 작성자 ID
    let nick: String               // 작성자 닉네임
    let profileImage: String?      // 프로필 이미지 (선택적)
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}

struct Comment: Codable {
    let commentId: String          // 댓글 ID
    let content: String            // 댓글 내용
    let createdAt: String          // 댓글 작성 날짜
    let creator: Creator           // 댓글 작성자 정보
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt
        case creator
    }
}



//MARK: - 댓글
struct CommentResponse: Codable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: CommentCreator
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt
        case creator
    }
}

struct CommentCreator: Codable {
    let userId: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
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
    
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        return indicator
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
        activityIndicator.center = view.center
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

        // 애니메이션 추가
        AnimationZip.animateButtonPress(submitButton)
        
        if selectedImages.isEmpty {
            // 이미지가 없는 경우 게시글만 업로드
            uploadPost(withImageURLs: [])
        } else {
            // 이미지를 하나씩 업로드하고 결과를 사용하여 게시글 업로드
            uploadImagesAndPost()
        }
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
            
            print("이미지 데이터 크기: \(imageData.count) bytes") // 이미지 데이터 크기 확인
            
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
        activityIndicator.startAnimating() // 로딩 시작

        let title = "우아아아아앙ㅇ아아"
        let content = reviewTextView.text ?? ""
        let productId: String? = nil

        print("업로드할 이미지 URL: \(imageUrls)")

        PostNetworkManager.shared.createPost(
            title: title,
            content: content,
            productId: productId,
            fileURLs: imageUrls
        ) { result in
            self.activityIndicator.stopAnimating() // 로딩 종료
            
            switch result {
            case .success:
                print("게시글 업로드 성공")
                self.reviewTextView.text = "" // 입력 필드 초기화
                self.selectedImages.removeAll() // 이미지 목록 초기화
                self.updatePhotoCountLabel() // 이미지 카운트 라벨 업데이트
                self.updateSubmitButtonState() // 제출 버튼 상태 업데이트
                
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

