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
    let age: String
    let image: UIImage
}

class GameViewController: BaseGameView {
    
    let pets: [Pet] = [
        Pet(name: "벼루님", age: "냥생 3개월차", image: UIImage(named: "기본냥멍1")!),
        Pet(name: "꼬질이님", age: "견생 5년차", image: UIImage(named: "기본냥멍2")!),
        Pet(name: "3님", age: "냥생 3개월차", image: UIImage(named: "기본냥멍3")!),
        Pet(name: "4님", age: "견생 5년차", image: UIImage(named: "기본냥멍4")!),
        Pet(name: "5님", age: "냥생 3개월차", image: UIImage(named: "기본냥멍5")!),
        Pet(name: "6님", age: "견생 5년차", image: UIImage(named: "기본냥멍6")!),
        Pet(name: "7님", age: "견생 5년차", image: UIImage(named: "기본냥멍7")!),
    ]
    
    let rounds: [String] = ["32강", "16강", "8강", "4강", "결승"]
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
            firstPriceLabel.text = pet.age
            currentPetIndex = newPetIndex
        } else if containerView == secondContainerView {
            secondImageView.image = pet.image
            secondNameLabel.text = pet.name
            secondPriceLabel.text = pet.age
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
            print("4강 우승자: \(selectedPet.name), 나이: \(selectedPet.age)")
        }
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
    
    
}

