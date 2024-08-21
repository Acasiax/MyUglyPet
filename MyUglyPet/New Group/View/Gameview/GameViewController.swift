//
//  GameViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/15/24.
//
//컬렋션뷰 prepatch items
//firstContainerView와 secondContainerView를 선택할 때

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

struct Pet {
    let name: String
    let hello: String
    let imageURL: String
}

final class GameViewController: BaseGameView {

    let disposeBag = DisposeBag()
    var pets: [Pet] = []

    var currentPetIndex: Int = 0
    var lastPetIndex: Int?
    
    let rounds: [String] = ["망한 사진 월드컵 32강", "망한 사진 월드컵 16강", "망한 사진 월드컵 8강", "망한 사진 월드컵 4강", "결승!"]
    var currentRoundIndex: Int = 0

    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           AnimationZip.startAnimations(firstContainerView: firstContainerView, secondContainerView: secondContainerView, titleLabel: titleLabel, worldCupLabel: worldCupLabel, in: view)
           showInitialPets()
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addsub()
        setupUI()
        fetchPosts()
        let firstContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFirstContainerTap))
        firstContainerView.addGestureRecognizer(firstContainerTapGesture)

        let secondContainerTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSecondContainerTap))
        secondContainerView.addGestureRecognizer(secondContainerTapGesture)

        
    }
    
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
                    hello: post.content ?? "기본 내용",
                    imageURL: "" // 이미지 URL이 없는 경우 빈 문자열로 설정
                )
            }
            
            let fullImageURLString = APIKey.baseURL + "v1/" + imageUrlString
            return Pet(
                name: post.title ?? "기본 이름",
                hello: post.content ?? "기본 내용",
                imageURL: fullImageURLString
            )
        }
        
        showInitialPets()
    }

    private func showInitialPets() {
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
            firstPriceLabel.text = pet.hello
            loadImage(for: pet, into: firstImageView)
            currentPetIndex = newPetIndex
        } else if containerView == secondContainerView {
            secondNameLabel.text = pet.name
            secondPriceLabel.text = pet.hello
            loadImage(for: pet, into: secondImageView)
            lastPetIndex = newPetIndex
        }
    }

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

   @objc func handleFirstContainerTap() {
        print("첫번째 컨테이너가 선택되었습니다.")
        let selectedPet = pets[currentPetIndex]
        checkForFinalWinner(selectedPet: selectedPet)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.showNextPet(in: self.secondContainerView)
        }
    }

    @objc func handleSecondContainerTap() {
        print("두번째 컨테이너가 선택되었습니다.")
        if let lastPetIndex = lastPetIndex {
            let selectedPet = pets[lastPetIndex]
            checkForFinalWinner(selectedPet: selectedPet)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.showNextPet(in: self.firstContainerView)
            }
        }
    }

    func showWinnerContainerView(with pet: Pet) {
        winnerNameLabel.text = pet.name
        winnerAgeLabel.text = pet.hello
        winnerImageView.image = UIImage(named: "placeholder") // 기본 이미지를 설정해 두었습니다

        basiclottieAnimationView.isHidden = true

        winnerTitleLabel.isHidden = false
        winnerContainerView.isHidden = false
        submitWinnerButton.isHidden = false

        winnerContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        
        animateWinnerContainerView()
    }

    func checkForFinalWinner(selectedPet: Pet) {
        if currentRoundIndex == 3 {
            print("4강 우승자: \(selectedPet.name), 나이: \(selectedPet.hello)")
            
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
}

//애니메이션
extension GameViewController {
    
    func animateWinnerContainerView() {
        self.pinklottieAnimationView.isHidden = true
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.winnerContainerView.layer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 1, 0)
        }) { _ in
            UIView.animate(withDuration: 1.0, animations: {
                self.winnerContainerView.layer.transform = CATransform3DIdentity
            }) { _ in
                self.congratulationAnimationView.isHidden = false
                self.congratulationAnimationView.play()
                
                self.pinklottieAnimationView.isHidden = false
                self.pinklottieAnimationView.play()
            }
        }
    }
}
