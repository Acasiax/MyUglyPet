//
//  NameInputViewModel.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa

class NameInputViewModel {
    
    struct Input {
        let nameText: Observable<String>
        let nextButtonTap: Observable<Void>
    }
    
    struct Output {
        let isNextButtonEnabled: Driver<Bool>
        let navigateToNextScreen: Observable<String>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let isNextButtonEnabled = input.nameText
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        let navigateToNextScreen = input.nextButtonTap
            .withLatestFrom(input.nameText)
        
        return Output(
            isNextButtonEnabled: isNextButtonEnabled,
            navigateToNextScreen: navigateToNextScreen
        )
    }
}

