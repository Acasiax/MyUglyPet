//
//  GameViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/15/24.
//
//firstContainerView와 secondContainerView를 선택할 때
import UIKit
import SnapKit

struct Pet {
    let name: String
    let hello: String
    let image: UIImage
}

class GameViewController: BaseGameView {
    
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
        startAnimations()
        showInitialPets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.lightBeige
        addsub()
        setupUI()
        tapGest()
        basiclottieAnimationView.play()
        
    }
    
    func tapGest() {
        let firstTapGesture = UITapGestureRecognizer(target: self, action: #selector(firstContainerTapped))
        firstContainerView.addGestureRecognizer(firstTapGesture)
        
        let secondTapGesture = UITapGestureRecognizer(target: self, action: #selector(secondContainerTapped))
        secondContainerView.addGestureRecognizer(secondTapGesture)
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
        if currentRoundIndex == 3 { // 현재 라운드가 4강인지 확인
            print("4강 우승자: \(selectedPet.name), 나이: \(selectedPet.hello)")
            
            // 첫 번째 컨테이너와 두 번째 컨테이너를 숨깁니다.
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
               
                
                // 우승자의 정보를 설정하고 winnerContainerView를 표시합니다.
                self.showWinnerContainerView(with: selectedPet)
            }
        }
    }

    
    
    
    
    
    func showWinnerContainerView(with pet: Pet) {
        // 우승자의 정보를 winnerContainerView에 설정
        winnerNameLabel.text = pet.name
        winnerAgeLabel.text = pet.hello
        winnerImageView.image = pet.image
        
        // basiclottieAnimationView를 숨기기
           basiclottieAnimationView.isHidden = true

        
        winnerTitleLabel.isHidden = false
        // winnerContainerView를 화면에 표시
        winnerContainerView.isHidden = false
  
       
        winnerContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        
        //우승자 카드 회전해서 나오는 애니메이션
        animateWinnerContainerView()
    }

    
   


    
    @objc func firstContainerTapped() {
        print("첫번째 컨테이너가 선택되었습니다.")
        let selectedPet = pets[currentPetIndex]
        checkForFinalWinner(selectedPet: selectedPet)
        
        animateContainerView(firstContainerView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.updateRound()
            if self.currentRoundIndex < self.rounds.count - 1 {
                self.startAnimations()
                self.showNextPet(in: self.secondContainerView)
                self.animateDescriptionLabel()
            }
        }
    }
    
    @objc func secondContainerTapped() {
        print("두번째 컨테이너가 선택되었습니다.")
        let selectedPet = pets[lastPetIndex!]
        checkForFinalWinner(selectedPet: selectedPet)
        
        animateContainerView(secondContainerView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.updateRound()
            if self.currentRoundIndex < self.rounds.count - 1 {
                self.startAnimations()
                self.showNextPet(in: self.firstContainerView)
                self.animateDescriptionLabel()
            }
        }
    }
}







//애니메이션 코드
extension GameViewController {
    
    func startAnimations() {
        // 처음 위치를 화면 아래로 설정
        firstContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        secondContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        
        // 첫 번째 컨테이너 애니메이션
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.firstContainerView.transform = .identity  // 첫 번째 컨테이너 원래 위치로 복원
        }, completion: nil)
        
        // 두 번째 컨테이너 애니메이션 (첫 번째 컨테이너 시작 후 0.2초 지연)
        UIView.animate(withDuration: 1.5, delay: 0.08, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.secondContainerView.transform = .identity  // 두 번째 컨테이너 원래 위치로 복원
        }, completion: nil)
        
        // titleLabel과 worldCupLabel 애니메이션 (첫 번째 컨테이너와 동시에 시작)
        titleLabel.transform = CGAffineTransform(translationX: 0, y: 10)
        worldCupLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 1.0, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.titleLabel.transform = .identity
            self.worldCupLabel.transform = .identity
        }, completion: nil)
    }

    
    // 살짝 확대된 후 복원하는 애니메이션
    func animateContainerView(_ view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { (_) in
            UIView.animate(withDuration: 0.1) {
                view.transform = CGAffineTransform.identity
            }
        }
    }
    
    
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


    
    
    //몇강 라운드인지 알려주는 애니메이션
    func animateDescriptionLabel() {
        // 확대 시작 상태 (1.2배로 확대)
        descriptionLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        // 애니메이션 적용
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            // 확대된 상태에서 원래 상태로 되돌립니다.
            self.descriptionLabel.transform = .identity
        }, completion: nil)
    }

    
}

