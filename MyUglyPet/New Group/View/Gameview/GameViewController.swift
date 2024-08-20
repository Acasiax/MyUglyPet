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

struct Pet {
    let name: String
    let hello: String
    let image: UIImage
}

final class GameViewController: BaseGameView {

    let disposeBag = DisposeBag()

    let pets: [Pet] = [
        Pet(name: "벼루님", hello: "뭘보냥?", image: UIImage(named: "기본냥멍1")!),
        Pet(name: "꼬질이님", hello: "퇴근후 기절각", image: UIImage(named: "기본냥멍2")!),
        Pet(name: "3님", hello: "꿀잠이다멍", image: UIImage(named: "기본냥멍3")!),
        Pet(name: "4님", hello: "멈칫", image: UIImage(named: "기본냥멍4")!),
        Pet(name: "5님", hello: "식칼어딨어멍멍", image: UIImage(named: "기본냥멍5")!),
        Pet(name: "6님", hello: "왔냐?", image: UIImage(named: "기본냥멍6")!),
        Pet(name: "7님", hello: "주인아밥줘라", image: UIImage(named: "기본냥멍7")!),
    ]
    
    let rounds: [String] = ["망한 사진 월드컵 32강", "망한 사진 월드컵 16강", "망한 사진 월드컵 8강", "망한 사진 월드컵 4강", "결승!"]
    var currentRoundIndex: Int = 0
    var currentPetIndex: Int = 0
    var lastPetIndex: Int?

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
        setupBindings()
        basiclottieAnimationView.play()
    }
    
    private func setupBindings() {
        // 첫 번째 컨테이너 탭 이벤트 처리
        let firstTapGesture = UITapGestureRecognizer()
        firstContainerView.addGestureRecognizer(firstTapGesture)
        
        firstTapGesture.rx.event
            .bind { [weak self] _ in
                self?.handleFirstContainerTap()
            }
            .disposed(by: disposeBag)
        
        // 두 번째 컨테이너 탭 이벤트 처리
        let secondTapGesture = UITapGestureRecognizer()
        secondContainerView.addGestureRecognizer(secondTapGesture)
        
        secondTapGesture.rx.event
            .bind { [weak self] _ in
                self?.handleSecondContainerTap()
            }
            .disposed(by: disposeBag)
    }

    private func handleFirstContainerTap() {
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

    private func handleSecondContainerTap() {
        print("두번째 컨테이너가 선택되었습니다.")
        if let lastPetIndex = lastPetIndex {
            let selectedPet = pets[lastPetIndex]
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
    
    func showInitialPets() {
        showNextPet(in: firstContainerView)
        showNextPet(in: secondContainerView)
    }
    
    func showNextPet(in containerView: UIView) {
        var newPetIndex: Int
        repeat {
            newPetIndex = Int.random(in: 0..<pets.count)
        } while newPetIndex == currentPetIndex || newPetIndex == lastPetIndex
        
        let pet = pets[newPetIndex]
        
        if containerView == firstContainerView {
            firstImageView.image = pet.image
            firstNameLabel.text = pet.name
            firstPriceLabel.text = pet.hello
            currentPetIndex = newPetIndex
        } else if containerView == secondContainerView {
            secondImageView.image = pet.image
            secondNameLabel.text = pet.name
            secondPriceLabel.text = pet.hello
            lastPetIndex = newPetIndex
        }
    }
    
    func updateRound() {
        currentRoundIndex += 1
        if currentRoundIndex < rounds.count {
            descriptionLabel.text = rounds[currentRoundIndex]
        }
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

    func showWinnerContainerView(with pet: Pet) {
        winnerNameLabel.text = pet.name
        winnerAgeLabel.text = pet.hello
        winnerImageView.image = pet.image

        basiclottieAnimationView.isHidden = true

        winnerTitleLabel.isHidden = false
        winnerContainerView.isHidden = false
        submitWinnerButton.isHidden = false

        winnerContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        
        animateWinnerContainerView()
    }
}







////애니메이션 코드
extension GameViewController {
    
    //우승자 카드 회전해서 나오는 애니메이션
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

