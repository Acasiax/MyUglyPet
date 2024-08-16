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
        Pet(name: "꼬질이님", age: "견생 5년차", image: UIImage(named: "기본냥")!),
        Pet(name: "3님", age: "냥생 3개월차", image: UIImage(named: "기본냥")!),
        Pet(name: "4님", age: "견생 5년차", image: UIImage(named: "기본냥")!),
        Pet(name: "5", age: "냥생 3개월차", image: UIImage(named: "기본냥")!),
        Pet(name: "6님", age: "견생 5년차", image: UIImage(named: "기본냥")!)
       
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
        
        // titleLabel 애니메이션 초기 설정 (살짝 아래에 위치)
        titleLabel.transform = CGAffineTransform(translationX: 0, y: 10)
        worldCupLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        // 애니메이션 블록
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.firstContainerView.transform = .identity  // 원래 위치로 복원
            self.secondContainerView.transform = .identity
        }, completion: nil)
        
        // titleLabel 애니메이션 (아래에서 위로 살짝 올라오는 효과)
        UIView.animate(withDuration: 1.0, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.titleLabel.transform = .identity // 원래 위치로 복원
            self.worldCupLabel.transform = .identity // 원래 크기로 복원
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

