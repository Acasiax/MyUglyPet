//
//  EditPostViewModel.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EditPostViewModel {
    
    struct Input {
        let confirmTap: Observable<Void>
        let titleText: Observable<String?>
        let contentText: Observable<String?>
    }
    
    struct Output {
        let isConfirmEnabled: Driver<Bool>
        let updatedData: Observable<(String, String)>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let titleAndContent = Observable.combineLatest(input.titleText, input.contentText)
        
        let isConfirmEnabled = titleAndContent
            .map { title, content in
                return (title?.isEmpty == false) && (content?.isEmpty == false)
            }
            .asDriver(onErrorJustReturn: false)
        
        let updatedData = input.confirmTap
            .withLatestFrom(titleAndContent)
            .compactMap { title, content -> (String, String)? in
                guard let title = title, let content = content else { return nil }
                return (title, content)
            }
        
        return Output(isConfirmEnabled: isConfirmEnabled, updatedData: updatedData)
    }
}
