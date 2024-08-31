//
//  FollowersViewModel.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/31/24.
//

import Foundation
import RxSwift
import RxCocoa

class FollowersViewModel {
    
    struct Input {
        let fetchFollowers: Observable<MyProfileResponse?>
    }
    
    struct Output {
        let followers: Driver<[MyUser]>
        let error: Driver<String>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let followersRelay = BehaviorRelay<[MyUser]>(value: [])
        let errorRelay = PublishRelay<String>()
        
        input.fetchFollowers
            .compactMap { $0?.followers } // MyProfileResponse에서 followers를 추출
            .catch { error in
                errorRelay.accept("팔로워 데이터를 불러오는 중 에러가 발생했습니다.")
                return Observable.just([])
            }
            .bind(to: followersRelay)
            .disposed(by: disposeBag)
        
        return Output(
            followers: followersRelay.asDriver(),
            error: errorRelay.asDriver(onErrorJustReturn: "알 수 없는 오류가 발생했습니다.")
        )
    }
}
