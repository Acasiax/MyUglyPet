//
//  DeepPhotoViewModel.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//

import Foundation
import RxSwift
import RxCocoa

class DeepPhotoViewModel {
    
    struct Input {
        let closeButtonTap: Observable<Void>
        let selectedIndex: Observable<Int>
    }
    
    struct Output {
        let currentPage: Driver<Int>
        let close: Driver<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let currentPage = input.selectedIndex.asDriver(onErrorJustReturn: 0)
        
        let close = input.closeButtonTap
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(currentPage: currentPage, close: close)
    }
}
