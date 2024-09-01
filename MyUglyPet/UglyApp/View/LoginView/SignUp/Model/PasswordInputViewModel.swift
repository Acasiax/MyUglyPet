//
//  PasswordInputViewModel.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordInputViewModel {

    struct Input {
        let passwordText: Observable<String>
        let togglePasswordVisibility: Observable<Void>
        let nextButtonTap: Observable<Void>
    }
    

    struct Output {
        let isNextButtonEnabled: Driver<Bool>
        let isPasswordVisible: Driver<Bool>
        let showSuccessMessage: Driver<String>
        let showErrorMessage: Driver<String>
    }
    
    private let disposeBag = DisposeBag()
    

    func transform(input: Input) -> Output {
        let isPasswordVisibleRelay = BehaviorRelay<Bool>(value: false)
        
        let isNextButtonEnabled = input.passwordText
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        let isPasswordVisible = input.togglePasswordVisibility
            .withLatestFrom(isPasswordVisibleRelay)
            .map { !$0 }
            .do(onNext: isPasswordVisibleRelay.accept)
            .asDriver(onErrorJustReturn: false)
        
        let showSuccessMessage = PublishRelay<String>()
        let showErrorMessage = PublishRelay<String>()
        
        input.nextButtonTap
            .withLatestFrom(input.passwordText)
            .subscribe(onNext: { [weak self] password in
                self?.registerUser(email: "test@example.com", nickname: "nickname", password: password)
                    .subscribe { result in
                        switch result {
                        case .success(let message):
                            showSuccessMessage.accept(message)
                        case .failure(let error):
                            showErrorMessage.accept(error.localizedDescription)
                        }
                    }
                    .disposed(by: self?.disposeBag ?? DisposeBag())
            })
            .disposed(by: disposeBag)
        
        return Output(
            isNextButtonEnabled: isNextButtonEnabled,
            isPasswordVisible: isPasswordVisible,
            showSuccessMessage: showSuccessMessage.asDriver(onErrorJustReturn: ""),
            showErrorMessage: showErrorMessage.asDriver(onErrorJustReturn: "")
        )
    }
    
    // MARK: - 네트워크 호출
    private func registerUser(email: String, nickname: String, password: String) -> Observable<Result<String, Error>> {
        return Observable.create { observer in
            SignUpPostNetworkManager.registerUser(email: email, password: password, nick: nickname, phoneNum: "11", birthDay: "2000") { result in
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
