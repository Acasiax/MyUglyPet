//
//  AnimationUtility.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/17/24.
//

import UIKit
import Lottie

class AnimationZip {
    
    // 버튼에 작아졌다 복구되는 애니메이션을 적용하는 함수
    static func animateButtonPress(_ button: UIButton, scale: CGFloat = 0.9, duration: TimeInterval = 0.1) {
        UIView.animate(withDuration: duration, animations: {
            button.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) { _ in
            UIView.animate(withDuration: duration) {
                button.transform = CGAffineTransform.identity
            }
        }
    }
    
    
    
    //MARK: -

    // 컨테이너 뷰를 아래에서 위로 이동시키는 애니메이션
    static func startAnimations(firstContainerView: UIView, secondContainerView: UIView, titleLabel: UILabel, worldCupLabel: UILabel, in view: UIView) {
        firstContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        secondContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            firstContainerView.transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 1.5, delay: 0.08, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            secondContainerView.transform = .identity
        }, completion: nil)
        
        titleLabel.transform = CGAffineTransform(translationX: 0, y: 10)
        worldCupLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 1.0, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            titleLabel.transform = .identity
            worldCupLabel.transform = .identity
        }, completion: nil)
    }

    // 살짝 확대된 후 복원하는 애니메이션
    static func animateContainerView(_ view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                view.transform = CGAffineTransform.identity
            }
        }
    }

    // 몇 강 라운드인지 알려주는 애니메이션
    static func animateDescriptionLabel(_ label: UILabel) {
        label.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            label.transform = .identity
        }, completion: nil)
    }
}
