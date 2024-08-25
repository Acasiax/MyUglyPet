//
//  GameViewAnimation.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit

// MARK: - 애니메이션
extension GameViewController {
    func animateWinnerContainerView() {
        // 카드 회전 전에 Lottie 애니메이션 숨기기
        self.pinkLottieAnimationView.isHidden = true
      
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
                
                self.pinkLottieAnimationView.isHidden = false
                self.pinkLottieAnimationView.play()
            }
        }
    }
}

