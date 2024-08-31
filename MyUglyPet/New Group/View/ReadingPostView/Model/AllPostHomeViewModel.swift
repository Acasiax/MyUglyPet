//
//  AllPostHomeViewModel.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa

// ViewModel 설계
final class AllPostHomeViewModel {
    struct Input {
        let plusButtonTap: Observable<Void>
    }
    
    struct Output {
        let navigateToCreatePost: Driver<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let navigateToCreatePost = input.plusButtonTap
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(navigateToCreatePost: navigateToCreatePost)
    }
}
