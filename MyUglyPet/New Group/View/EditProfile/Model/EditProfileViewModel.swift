//
//  EditProfileViewModel.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/31/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EditProfileViewModel {
    
    struct Input {
        let followersButtonTap: Observable<Void>
        let postsButtonTap: Observable<Void>
        let followingButtonTap: Observable<Void>
        let profileImageButtonTap: Observable<Void>
        let myLikedPostsButtonTap: Observable<Void>
        let editProfileButtonTap: Observable<Void>
        let viewFollowingButtonTap: Observable<Void>
        let viewFollowersButtonTap: Observable<Void>
        let logoutButtonTap: Observable<Void>
        let deleteAccountButtonTap: Observable<Void>
    }
    
    struct Output {
        let navigateToFollowers: Driver<Void>
        let navigateToPosts: Driver<Void>
        let navigateToFollowing: Driver<Void>
        let showProfileImageOptions: Driver<Void>
        let navigateToMyLikedPosts: Driver<Void>
        let navigateToEditProfile: Driver<Void>
        let navigateToViewFollowing: Driver<Void>
        let navigateToViewFollowers: Driver<Void>
        let performLogout: Driver<Void>
        let performDeleteAccount: Driver<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let navigateToFollowers = input.followersButtonTap
            .asDriver(onErrorJustReturn: ())
        
        let navigateToPosts = input.postsButtonTap
            .asDriver(onErrorJustReturn: ())
        
        let navigateToFollowing = input.followingButtonTap
            .asDriver(onErrorJustReturn: ())
        
        let showProfileImageOptions = input.profileImageButtonTap
            .asDriver(onErrorJustReturn: ())
        
        let navigateToMyLikedPosts = input.myLikedPostsButtonTap
            .asDriver(onErrorJustReturn: ())
        
        let navigateToEditProfile = input.editProfileButtonTap
            .asDriver(onErrorJustReturn: ())
        
        let navigateToViewFollowing = input.viewFollowingButtonTap
            .asDriver(onErrorJustReturn: ())
        
        let navigateToViewFollowers = input.viewFollowersButtonTap
            .asDriver(onErrorJustReturn: ())
        
        let performLogout = input.logoutButtonTap
            .asDriver(onErrorJustReturn: ())
        
        let performDeleteAccount = input.deleteAccountButtonTap
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            navigateToFollowers: navigateToFollowers,
            navigateToPosts: navigateToPosts,
            navigateToFollowing: navigateToFollowing,
            showProfileImageOptions: showProfileImageOptions,
            navigateToMyLikedPosts: navigateToMyLikedPosts,
            navigateToEditProfile: navigateToEditProfile,
            navigateToViewFollowing: navigateToViewFollowing,
            navigateToViewFollowers: navigateToViewFollowers,
            performLogout: performLogout,
            performDeleteAccount: performDeleteAccount
        )
    }
}
