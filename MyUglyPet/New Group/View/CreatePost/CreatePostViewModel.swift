//
//  CreatePostViewModel.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import RxSwift
import RxCocoa

final class CreatePostViewModel {
    struct Input {
        let reviewText: Observable<String>
    }

    struct Output {
        let characterCount: Driver<String>
        let isSubmitButtonEnabled: Driver<Bool>
    }

    func transform(input: Input) -> Output {
        let characterCount = input.reviewText
            .map { "\($0.count)" }
            .asDriver(onErrorJustReturn: "0")

        let isSubmitButtonEnabled = input.reviewText
            .map { $0.count >= 5 }
            .asDriver(onErrorJustReturn: false)

        return Output(
            characterCount: characterCount,
            isSubmitButtonEnabled: isSubmitButtonEnabled
        )
    }
}
