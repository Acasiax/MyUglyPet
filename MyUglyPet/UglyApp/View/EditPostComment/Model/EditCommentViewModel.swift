//
//  EditCommentViewModel.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EditCommentViewModel {
    
    struct Input {
        let confirmTap: Observable<Void>
        let commentText: Observable<String?>
    }
    
    struct Output {
        let isConfirmEnabled: Driver<Bool>
        let updatedComment: Observable<String>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let isConfirmEnabled = input.commentText
            .map { $0?.isEmpty == false }
            .asDriver(onErrorJustReturn: false)
        
        let updatedComment = input.confirmTap
            .withLatestFrom(input.commentText)
            .compactMap { $0 }
        
        return Output(isConfirmEnabled: isConfirmEnabled, updatedComment: updatedComment)
    }
}

