//
//  UglyCandidateViewModel.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class UglyCandidateViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let imageButtonTap: Observable<Void>
        let submitButtonTap: Observable<Void>
        let selectedImage: Observable<UIImage?>
        let photoTitle: Observable<String?>
        let userName: Observable<String?>
    }

    struct Output {
        let presentImagePicker: Observable<Void>
        let uploadResult: Observable<Result<Void, Error>>
        let validationError: Observable<String>
    }

    
    
    func transform(input: Input) -> Output {
        let presentImagePicker = input.imageButtonTap
            .do(onNext: { print("이미지 버튼 탭 이벤트") })

        let selectedImageSubject = BehaviorSubject<UIImage?>(value: nil)
        input.selectedImage
            .bind(to: selectedImageSubject)
            .disposed(by: disposeBag)

        let validationError = input.submitButtonTap
            .withLatestFrom(Observable.combineLatest(input.photoTitle, input.userName, selectedImageSubject)) { ($0, $1.0, $1.1, $1.2) }
            .flatMap { (_, title, userName, selectedImage) -> Observable<String> in
                var errorMessage = ""
                
                if selectedImage == nil {
                    errorMessage += "이미지를 선택해주세요.\n"
                }
                if title?.isEmpty ?? true {
                    errorMessage += "사진 제목을 입력해주세요.\n"
                }
                if userName?.isEmpty ?? true {
                    errorMessage += "사용자 이름을 입력해주세요.\n"
                }
                
                if !errorMessage.isEmpty {
                    return Observable.just(errorMessage)
                } else {
                    return Observable.just("")
                }
            }
            .filter { !$0.isEmpty }

        let uploadResult = input.submitButtonTap
            .withLatestFrom(Observable.combineLatest(input.photoTitle, input.userName, selectedImageSubject)) { ($0, $1.0, $1.1, $1.2) }
            .filter { $1 != nil && $2 != nil && $3 != nil }
            .flatMapLatest { (_, title, userName, selectedImage) -> Observable<Result<Void, Error>> in
                return self.uploadImagesAndPost(title: title!, userName: userName!, image: selectedImage!)
            }

        return Output(
            presentImagePicker: presentImagePicker,
            uploadResult: uploadResult,
            validationError: validationError
        )
    }

    

    // 이미지 및 게시글 업로드 함수
    private func uploadImagesAndPost(title: String, userName: String, image: UIImage) -> Observable<Result<Void, Error>> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onNext(.failure(NSError(domain: "SelfError", code: -1, userInfo: nil)))
                observer.onCompleted()
                return Disposables.create()
            }

            var uploadedImageUrls: [String] = []
            let dispatchGroup = DispatchGroup()

            if let imageData = image.jpegData(compressionQuality: 0.8) {
                dispatchGroup.enter()
                let imageUploadQuery = ImageUploadQuery(files: imageData)
                
                PostNetworkManager.shared.uploadPostImage(query: imageUploadQuery) { result in
                    switch result {
                    case .success(let imageUrls):
                        uploadedImageUrls.append(contentsOf: imageUrls)
                    case .failure(let error):
                        observer.onNext(.failure(error))
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                if uploadedImageUrls.isEmpty {
                    observer.onNext(.failure(NSError(domain: "UploadError", code: -1, userInfo: nil)))
                } else {
                    self.uploadPost(withImageURLs: uploadedImageUrls, title: title, userName: userName)
                        .subscribe(observer)
                        .disposed(by: self.disposeBag)
                }
            }

            return Disposables.create()
        }
    }

    private func uploadPost(withImageURLs imageUrls: [String], title: String, userName: String) -> Observable<Result<Void, Error>> {
        return Observable.create { observer in
            let productId: String? = "못난이후보등록"
            
            PostNetworkManager.shared.createPost(
                title: title,
                content: "",
                content1: userName,
                content3: "", //위도 안씀
                content4: "", // 경도 안씀
                productId: productId,
                fileURLs: imageUrls
            ) { result in
                switch result {
                case .success:
                    observer.onNext(.success(()))
                case .failure(let error):
                    observer.onNext(.failure(error))
                }
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }
}
