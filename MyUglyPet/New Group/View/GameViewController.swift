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
        Pet(name: "벼루님", age: "냥생 3개월차", image: UIImage(named: "기본냥")!),
        Pet(name: "꼬질이님", age: "견생 5년차", image: UIImage(named: "기본냥멍2")!),
        Pet(name: "3님", age: "냥생 3개월차", image: UIImage(named: "기본냥멍3")!),
        Pet(name: "4님", age: "견생 5년차", image: UIImage(named: "기본냥멍4")!),
        Pet(name: "5", age: "냥생 3개월차", image: UIImage(named: "기본냥멍5")!),
        Pet(name: "6님", age: "견생 5년차", image: UIImage(named: "기본냥멍6")!),
        Pet(name: "7님", age: "견생 5년차", image: UIImage(named: "기본냥멍7")!)
       
    ]
    let rounds: [String] = ["32강", "16강", "8강", "4강"]
    var currentRoundIndex: Int = 0
    
    var currentPetIndex: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.00, green: 0.98, blue: 0.88, alpha: 1.00)
        addsub()
        setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(firstContainerTapped))
        view.addGestureRecognizer(tapGesture)
        let secondTapGesture = UITapGestureRecognizer(target: self, action: #selector(secondContainerTapped))
        secondContainerView.addGestureRecognizer(secondTapGesture)
    }
    
    func showNextPet(in containerView: UIView) {
        currentPetIndex = (currentPetIndex + 1) % pets.count
        let pet = pets[currentPetIndex]
        
        if containerView == firstContainerView {
            firstImageView.image = pet.image
            firstNameLabel.text = pet.name
            firstPriceLabel.text = pet.age
        } else if containerView == secondContainerView {
            secondImageView.image = pet.image
            secondNameLabel.text = pet.name
            secondPriceLabel.text = pet.age
        }
    }
    
    // 현재 라운드를 업데이트하고 라벨에 반영
    func updateRound() {
        currentRoundIndex = (currentRoundIndex + 1) % rounds.count
        descriptionLabel.text = rounds[currentRoundIndex]
    }
    
    
    @objc func firstContainerTapped() {
        print("첫번째 컨테이너가 선택되었습니다.")
        animateContainerView(firstContainerView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.updateRound()
            self.startAnimations()
            self.showNextPet(in: self.secondContainerView)
        }
        
        
    }
    
    
    @objc func secondContainerTapped() {
        print("두번째 컨테이너가 선택되었습니다.")
        animateContainerView(secondContainerView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.updateRound()
            self.startAnimations()
            self.showNextPet(in: self.firstContainerView)
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

