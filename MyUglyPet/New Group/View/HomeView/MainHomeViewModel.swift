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
                if index == 0 {
                    return GameViewController()
                } else {
                    return IntroUglyCandidateViewController()
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
