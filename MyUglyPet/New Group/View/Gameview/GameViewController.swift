//
//  GameViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/15/24.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire
import RxSwift
import RxCocoa



final class GameViewController: UIViewController {

    var pets: [Pet] = []
    var currentPetIndex: Int = 0
    var lastPetIndex: Int?
    var currentRoundIndex: Int = 0
    var winnerPet: Pet?  // 우승자 정보를 저장하는 변수
    let rounds: [String] = ["망한 사진 월드컵 16강", "망한 사진 월드컵 8강", "망한 사진 월드컵 4강", "결승!"]

    
    let disposeBag = DisposeBag()
    
    
    let basicLottieAnimationView = UIGameView.basicLottieAnimationView
    let pinkLottieAnimationView = UIGameView.pinkLottieAnimationView
    let congratulationAnimationView = UIGameView.congratulationAnimationView
    let worldCupLabel = UIGameView.worldCupLabel
    let titleLabel = UIGameView.titleLabel
    let descriptionLabel = UIGameView.descriptionLabel
    let submitWinnerButton = UIGameView.submitWinnerButton
    let firstContainerView = UIGameView.firstContainerView
    let firstImageView = UIGameView.firstImageView
    let firstNameLabel = UIGameView.firstNameLabel
    let firstPriceLabel = UIGameView.firstPriceLabel
    let secondContainerView = UIGameView.secondContainerView
    let secondImageView = UIGameView.secondImageView
    let secondNameLabel = UIGameView.secondNameLabel
    let secondPriceLabel = UIGameView.secondPriceLabel
    let vsLabel = UIGameView.vsLabel
    let winnerTitleLabel = UIGameView.winnerTitleLabel
    let winnerContainerView = UIGameView.winnerContainerView
    let winnerImageView = UIGameView.winnerImageView
    let winnerNameLabel = UIGameView.winnerNameLabel
    let winnerAgeLabel = UIGameView.winnerAgeLabel

    

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
        bindUI()
        fetchPosts()
        basicLottieAnimationView.play()
    }

    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           resetGameState() // 게임 상태 초기화
       }

    
    
    func bindUI() {
        // 첫 번째 컨테이너 탭 제스처
        let firstTapGesture = UITapGestureRecognizer()
        firstContainerView.addGestureRecognizer(firstTapGesture)
        firstTapGesture.rx.event
            .bind(with: self) { owner, _ in
                owner.firstContainerTapped()
            }
            .disposed(by: disposeBag)
        
        // 두 번째 컨테이너 탭 제스처
        let secondTapGesture = UITapGestureRecognizer()
        secondContainerView.addGestureRecognizer(secondTapGesture)
        secondTapGesture.rx.event
            .bind(with: self) { owner, _ in
                owner.secondContainerTapped()
            }
            .disposed(by: disposeBag)
        
        // 우승자 제출 버튼
        submitWinnerButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.submitWinnerButtonTapped()
            }
            .disposed(by: disposeBag)
    }

    func resetGameState() {
            // 게임 상태를 초기화하는 로직
            currentPetIndex = 0
            lastPetIndex = nil
            currentRoundIndex = 0
            winnerPet = nil
        }

}



extension GameViewController {
    // 여기 파일은 잘 로드됨🌟🔥
    func submitWinnerButtonTapped() {
        if let winner = winnerPet {
            print("🔥우승자 이름: \(winner.name), 인사말: \(winner.userName), 이미지 URL: \(winner.imageURL)")
            // 우승자 정보를 서버에 업로드
            uploadWinnerImageAndPost()
        } else {
            print("우승자가 설정되지 않았습니다.")
        }
  
        // 이전 화면으로 돌아가기
           navigationController?.popViewController(animated: true)
    }
    
    
    
    
}



// MARK: - firstContainerView와 secondContainerView를 선택할 때
extension GameViewController {
    
    func firstContainerTapped() {
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
    
    func secondContainerTapped() {
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
    
}
