//
//  CreatePostViewServerLogic.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit
import Alamofire

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
        
        let latitude = latitude
        let longitude = longitude
        print("📍 위도: \(String(describing: latitude)), 📍경도: \(longitude)")
        
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
            content3: latitude,
            content4: longitude,
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


extension CreatePostViewController {
    
    func fetchCurrentLocation() {
        print("🙆‍♀️ 위치 가져오기 시작 🙆‍♀️")
        
        // 위치 업데이트 콜백 등록
        LocationManager.shared.locationUpdateCallback = { [weak self] coordinate in
            // 위도와 경도 값을 String으로 변환하여 변수에 저장
            let latitudeString = String(format: "%.6f", coordinate.latitude)
            let longitudeString = String(format: "%.6f", coordinate.longitude)
            
            // self에 저장된 클래스 변수로 접근하여 저장
            self?.latitude = latitudeString
            self?.longitude = longitudeString
            
            // 디버깅을 위한 출력
            print("현재 위치 - 위도: \(latitudeString), 경도: \(longitudeString)")
        }
        
        // 현재 위치를 가져오기
        LocationManager.shared.requestLocationPermission()
        LocationManager.shared.fetchCurrentLocation()
    }
}

