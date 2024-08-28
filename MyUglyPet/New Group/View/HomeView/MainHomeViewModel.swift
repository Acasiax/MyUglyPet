//
//  MainHomeViewModel.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit
import RxSwift
import RxCocoa

struct MainHomeViewModel {
    struct Input {
        let missionSelected: Observable<Int>
        let petButtonTapped: Observable<Void>
        let uploadButtonTapped: Observable<Void>
    }

    struct Output {
        let missionToShow: Observable<UIViewController>
        let animatePetButton: Observable<Void>
        let animateUploadButton: Observable<Void>
    }

    func transform(input: Input, petButton: UIButton, uploadButton: UIButton) -> Output {
        let missionToShow = input.missionSelected
            .map { index -> UIViewController in
                switch index {
                case 0:
                    return GameViewController()
                case 1:
                    return IntroUglyCandidateViewController()
                case 2:
                    return GameViewController()
                default:
                    return UIViewController() // 기본값으로 빈 UIViewController를 반환하거나 다른 뷰 컨트롤러를 지정할 수 있습니다.
                }
            }

        let animatePetButton = input.petButtonTapped
            .do(onNext: {
                AnimationZip.animateButtonPress(petButton)
            })

        let animateUploadButton = input.uploadButtonTapped
            .do(onNext: {
                AnimationZip.animateButtonPress(uploadButton)
            })

        return Output(
            missionToShow: missionToShow,
            animatePetButton: animatePetButton,
            animateUploadButton: animateUploadButton
        )
    }

}
