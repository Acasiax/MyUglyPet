//
//  GameViewServerLogic.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit
import Alamofire
import Kingfisher

// MARK: - 게임 로직 함수
extension GameViewController {
    
    func showInitialPets() {
        showNextPet(in: firstContainerView)
        showNextPet(in: secondContainerView)
    }

     func showNextPet(in containerView: UIView) {
        guard pets.count > 0 else { return }

        var newPetIndex: Int
        repeat {
            newPetIndex = Int.random(in: 0..<pets.count)
        } while newPetIndex == currentPetIndex || newPetIndex == lastPetIndex

        let pet = pets[newPetIndex]

        if containerView == firstContainerView {
            firstNameLabel.text = pet.name
            firstPriceLabel.text = pet.userName
            loadImage(for: pet, into: firstImageView)
            currentPetIndex = newPetIndex
        } else if containerView == secondContainerView {
            secondNameLabel.text = pet.name
            secondPriceLabel.text = pet.userName
            loadImage(for: pet, into: secondImageView)
            lastPetIndex = newPetIndex
        }
    }

    func updateRound() {
        currentRoundIndex += 1
        if currentRoundIndex < rounds.count {
            descriptionLabel.text = rounds[currentRoundIndex]
        }
    }

    //🌟
    func checkForFinalWinner(selectedPet: Pet) {
        if currentRoundIndex == 2 { // 현재 라운드가 4강인지 확인
            print("4강 우승자(사진제목): \(selectedPet.name), 사용자이름: \(selectedPet.userName)")
            
            UIView.animate(withDuration: 0.5, animations: {
                self.titleLabel.alpha = 1
                self.firstContainerView.alpha = 1
                self.secondContainerView.alpha = 1
                self.vsLabel.alpha = 1
            }) { _ in
                self.titleLabel.isHidden = true
                self.firstContainerView.isHidden = true
                self.secondContainerView.isHidden = true
                self.vsLabel.isHidden = true
                
                self.showWinnerContainerView(with: selectedPet)
            }
        }
    }

    func showWinnerContainerView(with pet: Pet) {
        winnerNameLabel.text = pet.name
        winnerAgeLabel.text = pet.userName
        
        // 우승자 이미지 로드
        loadImage(for: pet, into: winnerImageView)

        basicLottieAnimationView.isHidden = true

        winnerTitleLabel.isHidden = false
        winnerContainerView.isHidden = false
        submitWinnerButton.isHidden = false

        winnerContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        
        // 우승자 정보 저장
        winnerPet = pet

        animateWinnerContainerView()
    }
}


// MARK: - 서버 데이터 가져올 때 메서드
extension GameViewController {
     func fetchPosts() {
        let query = FetchReadingPostQuery(next: nil, limit: "30", product_id: "못난이후보등록")

        PostNetworkManager.shared.fetchPosts(query: query) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.handleFetchedPosts(posts)
                print("🎮게임후보 포스팅을 가져오는데 성공했어요")
            case .failure(let error):
                print("🎮게임후보 포스팅을 가져오는데 실패했어요ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }

    func handleFetchedPosts(_ posts: [PostsModel]) {
        let headers = Router.fetchPosts(query: FetchReadingPostQuery(next: nil, limit: "10", product_id: "")).headersForImageRequest
        
        pets = posts.compactMap { post in
            guard let imageUrlString = post.files?.first else {
                print("타이틀이 없는 포스트에 대한 이미지 URL을 찾을 수 없습니다: \(post.title ?? "제목 없음")")
                return Pet(
                    name: post.title ?? "기본 이름",
                    userName: post.content ?? "기본 내용",
                    imageURL: "" // 이미지 URL이 없는 경우 빈 문자열로 설정
                )
            }
            
            let fullImageURLString = APIKey.baseURL + "v1/" + imageUrlString
            return Pet(
                name: post.title ?? "기본 이름",
                userName: post.content1 ?? "기본 내용",
                imageURL: fullImageURLString
            )
        }
        
        showInitialPets()
    }
    
    // MARK: - 이미지 로드 함수
     func loadImage(for pet: Pet, into imageView: UIImageView) {
        guard let imageURL = URL(string: pet.imageURL) else {
            print("잘못된 URL 문자열: \(pet.imageURL)")
            imageView.image = UIImage(named: "placeholder")
            return
        }

        let headers = Router.fetchPosts(query: FetchReadingPostQuery(next: nil, limit: "10", product_id: "")).headersForImageRequest

        let modifier = AnyModifier { request in
            var r = request
            r.allHTTPHeaderFields = headers
            return r
        }
        
        imageView.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "placeholder"),
            options: [.requestModifier(modifier)]
        ) { result in
            switch result {
            case .success(let value):
                print("이미지 로드 성공📩: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("이미지 로드 실패📩: \(error.localizedDescription)")
            }
        }
    }
}






// MARK: - 1등한 우승자를 서버에 포스팅하기
extension GameViewController {
    
    func removeBaseURL(from url: String) -> String {
        let baseURL = APIKey.baseURL + "v1/"
        if url.hasPrefix(baseURL) {
            return String(url.dropFirst(baseURL.count))
        } else {
            return url // baseURL이 포함되지 않은 경우 전체 URL을 반환
        }
    }

    // MARK: - 우승자 이미지 게시글 업로드 함수
    func uploadWinnerImageAndPost() {
        guard let winnerPet = winnerPet else {
            print("우승자가 설정되지 않았습니다.")
            return
        }

        guard let url = URL(string: winnerPet.imageURL) else {
            print("우승자 이미지 URL이 잘못되었습니다.")
            return
        }

        let dispatchGroup = DispatchGroup()
        var uploadedImageUrls: [String] = []

        dispatchGroup.enter()

        // Alamofire를 사용하여 비동기적으로 이미지 데이터를 가져옴
        AF.request(url).responseData { [weak self] response in
            guard let self = self else { return }

            switch response.result {
            case .success(let imageData):
                let imageUploadQuery = ImageUploadQuery(files: imageData)

                // baseURL을 제거한 후 uploadPostImage 메서드 호출
                let strippedURL = removeBaseURL(from: winnerPet.imageURL)

                WinnerPostNetworkManager.shared.uploadPostImage(query: imageUploadQuery, originalURL: strippedURL) { result in
                    switch result {
                    case .success(let imageUrls):
                        print("💡이미지 업로드 성공!!: \(imageUrls)")
                        uploadedImageUrls.append(contentsOf: imageUrls)
                    case .failure(let error):
                        print("이미지 업로드 실패: \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }

            case .failure(let error):
                print("이미지 데이터를 가져오는데 실패했습니다: \(error.localizedDescription)")
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            if uploadedImageUrls.isEmpty {
                print("모든 이미지 업로드 실패")
                let alert = UIAlertController(title: "오류", message: "이미지 업로드에 실패했습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("모든 이미지 업로드 성공, 업로드된 이미지 URLs: \(uploadedImageUrls)")
                self.uploadWinnerPost(withImageURLs: uploadedImageUrls, pet: winnerPet)
            }
        }
    }

    // 우승자 게시글 업로드 함수
    private func uploadWinnerPost(withImageURLs imageUrls: [String], pet: Pet) {
        let title = pet.name
        let content1 = pet.userName
        print("우승자 업로드 정보: 제목 - \(title), 내용 - \(content1), 이미지 URL - \(imageUrls)")

        PostNetworkManager.shared.createPost(
            title: title,
            content: "#1등이닷", // 해쉬태그
            content1: content1,
            content3: "",
            content4: "",
            productId: "각유저가고른1등우승자",
            fileURLs: imageUrls
        ) { result in
            switch result {
            case .success:
                print("우승자 게시글 업로드 성공")
            case .failure(let error):
                print("우승자 게시글 업로드 실패: \(error.localizedDescription)")
            }
        }
    }
}

