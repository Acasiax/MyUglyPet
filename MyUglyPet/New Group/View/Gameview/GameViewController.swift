//
//  GameViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/15/24.
//
//firstContainerView와 secondContainerView를 선택할 때

import UIKit
import SnapKit
import Kingfisher
import Alamofire

struct Pet {
    let name: String
    let userName: String
    let imageURL: String
}


final class GameViewController: BaseGameView {


    var pets: [Pet] = []
    var currentPetIndex: Int = 0
    var lastPetIndex: Int?
    var currentRoundIndex: Int = 0
    var winnerPet: Pet?  // 우승자 정보를 저장하는 변수
    let rounds: [String] = ["망한 사진 월드컵 32강", "망한 사진 월드컵 16강", "망한 사진 월드컵 8강", "망한 사진 월드컵 4강", "결승!"]


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnimationZip.startAnimations(firstContainerView: firstContainerView, secondContainerView: secondContainerView, titleLabel: titleLabel, worldCupLabel: worldCupLabel, in: view)
        showInitialPets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.lightBeige
        addsub()
        setupUI()
        tapGest()
        fetchPosts()
        basiclottieAnimationView.play()
    }


    func tapGest() {
        let firstTapGesture = UITapGestureRecognizer(target: self, action: #selector(firstContainerTapped))
        firstContainerView.addGestureRecognizer(firstTapGesture)
        
        let secondTapGesture = UITapGestureRecognizer(target: self, action: #selector(secondContainerTapped))
        secondContainerView.addGestureRecognizer(secondTapGesture)
        
        submitWinnerButton.addTarget(self, action: #selector(submitWinnerButtonTapped), for: .touchUpInside)
    }


    // MARK: - 사용자가 선택했을 떄
    @objc func firstContainerTapped() {
        print("첫번째 컨테이너가 선택되었습니다.")
        
        let selectedPet = pets[currentPetIndex]
        checkForFinalWinner(selectedPet: selectedPet)
        
        AnimationZip.animateContainerView(firstContainerView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.updateRound()
            if self.currentRoundIndex < self.rounds.count - 1 {
                AnimationZip.startAnimations(firstContainerView: self.firstContainerView, secondContainerView: self.secondContainerView, titleLabel: self.titleLabel, worldCupLabel: self.worldCupLabel, in: self.view)
                self.showNextPet(in: self.secondContainerView)
                AnimationZip.animateDescriptionLabel(self.descriptionLabel)
            }
        }
    }
    
    @objc func secondContainerTapped() {
        print("두번째 컨테이너가 선택되었습니다.")
        let selectedPet = pets[lastPetIndex!]
        checkForFinalWinner(selectedPet: selectedPet)
        
        AnimationZip.animateContainerView(secondContainerView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.updateRound()
            if self.currentRoundIndex < self.rounds.count - 1 {
                AnimationZip.startAnimations(firstContainerView: self.firstContainerView, secondContainerView: self.secondContainerView, titleLabel: self.titleLabel, worldCupLabel: self.worldCupLabel, in: self.view)
                self.showNextPet(in: self.firstContainerView)
                AnimationZip.animateDescriptionLabel(self.descriptionLabel)
            }
        }
    }

    @objc func submitWinnerButtonTapped() {
        if let winner = winnerPet {
            print("우승자 이름: \(winner.name), 인사말: \(winner.userName), 이미지 URL: \(winner.imageURL)")
        } else {
            print("우승자가 설정되지 않았습니다.")
        }
    }

}

// MARK: - 서버 데이터 가져 올때 메서드
extension GameViewController {
    private func fetchPosts() {
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

    private func handleFetchedPosts(_ posts: [PostsModel]) {
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
                userName: post.content ?? "기본 내용",
                imageURL: fullImageURLString
            )
        }
        
        showInitialPets()
    }
    
    // MARK: - 이미지 로드 함수
    private func loadImage(for pet: Pet, into imageView: UIImageView) {
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



// MARK: - 게임 로직 함수
extension GameViewController {
    
    func showInitialPets() {
        showNextPet(in: firstContainerView)
        showNextPet(in: secondContainerView)
    }

    private func showNextPet(in containerView: UIView) {
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
        if currentRoundIndex == 3 { // 현재 라운드가 4강인지 확인
            print("4강 우승자(사진제목): \(selectedPet.name), 사용자이름: \(selectedPet.userName)")
            
            UIView.animate(withDuration: 0.5, animations: {
                self.titleLabel.alpha = 0
                self.firstContainerView.alpha = 0
                self.secondContainerView.alpha = 0
                self.vsLabel.alpha = 0
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

        basiclottieAnimationView.isHidden = true

        winnerTitleLabel.isHidden = false
        winnerContainerView.isHidden = false
        submitWinnerButton.isHidden = false

        winnerContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        
        // 우승자 정보 저장
        winnerPet = pet

        animateWinnerContainerView()
        
        // 우승자 정보를 서버에 업로드
        uploadWinnerImageAndPost() // 변경된 부분
    }
}




// MARK: - 1등한 우승자를 서버에 포스팅하기
extension GameViewController {
    
    // MARK: - 우승자 이미지 및 게시글 업로드 함수
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
        let content = pet.userName

        print("우승자 업로드 정보: 제목 - \(title), 내용 - \(content), 이미지 URL - \(imageUrls)")

        PostNetworkManager.shared.createPost(
            title: title,
            content: content,
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


// MARK: - 애니메이션
extension GameViewController {
    func animateWinnerContainerView() {
        // 카드 회전 전에 Lottie 애니메이션 숨기기
        self.pinklottieAnimationView.isHidden = true
      
        // Y축 기준 90도 회전
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.winnerContainerView.layer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 1, 0)
        }) { _ in
            // 회전 상태를 초기화하여 원래 상태로 되돌립니다.
            UIView.animate(withDuration: 1.0, animations: {
                self.winnerContainerView.layer.transform = CATransform3DIdentity
            }) { _ in
                // 카드 회전 후 Lottie 애니메이션 다시 표시 및 재생
                self.congratulationAnimationView.isHidden = false
                self.congratulationAnimationView.play()
                
                self.pinklottieAnimationView.isHidden = false
                self.pinklottieAnimationView.play()
            }
        }
    }
}
