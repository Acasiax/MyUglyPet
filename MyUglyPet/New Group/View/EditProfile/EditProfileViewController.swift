//
//  EditProfileViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EditProfileViewController: UIViewController {
    
    lazy var profileImageButton = EditProfileUI.profileImageButton()
    lazy var userNameLabel = EditProfileUI.userNameLabel()
    lazy var userEmailLabel = EditProfileUI.userEmailLabel()
    lazy var profileStatsStackView = EditProfileUI.profileStatsStackView()
    lazy var notificationLabel = EditProfileUI.notificationLabel()
    lazy var logoutButton = EditProfileUI.logoutButton()
    lazy var deleteAccountButton = EditProfileUI.deleteAccountButton()
    lazy var managePostsButton = EditProfileUI.managePostsButton()
    lazy var editProfileButton = EditProfileUI.editProfileButton()
    lazy var viewFollowingButton = EditProfileUI.viewFollowingButton()
    lazy var viewFollowersButton = EditProfileUI.viewFollowersButton()
    lazy var buttonStackView = EditProfileUI.buttonStackView(withButtons: [
        managePostsButton, editProfileButton, viewFollowingButton, viewFollowersButton
    ])
    
    private let disposeBag = DisposeBag()
    
    var followersCountLabel: UILabel?
    var postsCountLabel: UILabel?
    var followingCountLabel: UILabel?
    
    var userProfile: MyProfileResponse?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.softIvory
        setupUI()
        bindButtons()
    }
    
    // MARK: - UI 설정
    
    private func setupUI() {
        setupProfileSection()
        setupStatsSection()
        setupBottomSection()
    }
    
    private func setupProfileSection() {
        view.addSubview(profileImageButton)
        view.addSubview(userNameLabel)
        view.addSubview(userEmailLabel)
        
        setupProfileSectionConstraints()
    }
    
    private func setupStatsSection() {
        followersCountLabel = EditProfileUI.statLabel(number: "0", title: "팔로워")
        postsCountLabel = EditProfileUI.statLabel(number: "0", title: "전체 게시물수")
        followingCountLabel = EditProfileUI.statLabel(number: "0", title: "팔로잉")
        
        profileStatsStackView.addArrangedSubview(followersCountLabel!)
        profileStatsStackView.addArrangedSubview(postsCountLabel!)
        profileStatsStackView.addArrangedSubview(followingCountLabel!)
        
        view.addSubview(profileStatsStackView)
        
        setupStatsSectionConstraints()
    }
    
    private func setupBottomSection() {
        view.addSubview(buttonStackView)
        view.addSubview(notificationLabel)
        view.addSubview(logoutButton)
        view.addSubview(deleteAccountButton)
        
        setupBottomSectionConstraints()
    }
    
    // MARK: - Action Methods
    
    private func bindButtons() {
        
        profileImageButton.rx.tap
            .bind(with: self) { owner, _ in
                AnimationZip.animateButtonPress(owner.profileImageButton)
                owner.handleProfileImageButtonTap()
            }
            .disposed(by: disposeBag)
        
        managePostsButton.rx.tap
            .bind(with: self) { owner, _ in
                AnimationZip.animateButtonPress(owner.managePostsButton)
                owner.handleManagePostsButtonTap()
            }
            .disposed(by: disposeBag)
        
        editProfileButton.rx.tap
            .bind(with: self) { owner, _ in
                AnimationZip.animateButtonPress(owner.editProfileButton)
                owner.handleEditProfileButtonTap()
            }
            .disposed(by: disposeBag)
        
        viewFollowingButton.rx.tap
            .bind(with: self) { owner, _ in
                AnimationZip.animateButtonPress(owner.viewFollowingButton)
                owner.handleViewFollowingButtonTap()
            }
            .disposed(by: disposeBag)
        
        viewFollowersButton.rx.tap
            .bind(with: self) { owner, _ in
                AnimationZip.animateButtonPress(owner.viewFollowersButton)
                owner.handleViewFollowersButtonTap()
            }
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .bind(with: self) { owner, _ in
                AnimationZip.animateButtonPress(owner.logoutButton)
                owner.handleLogout()
            }
            .disposed(by: disposeBag)
        
        deleteAccountButton.rx.tap
            .bind(with: self) { owner, _ in
                AnimationZip.animateButtonPress(owner.deleteAccountButton)
                owner.deleteAccount()
            }
            .disposed(by: disposeBag)
    }
}

extension EditProfileViewController {
    private func handleProfileImageButtonTap() {
        print("프로필 이미지 버튼이 눌렸습니다.")
    }
    
    private func handleManagePostsButtonTap() {
        print("게시글 관리 버튼이 눌렸습니다.")
    }
    
    private func handleEditProfileButtonTap() {
        print("프로필 수정 버튼이 눌렸습니다.")
    }
    
    private func handleViewFollowingButtonTap() {
        print("팔로잉 목록 버튼이 눌렸습니다.")
    }
    
    private func handleViewFollowersButtonTap() {
        print("팔로워 목록 버튼이 눌렸습니다.")
    }
    
    private func handleLogout() {
        print("로그아웃 버튼 눌림")
    }
    
    private func deleteAccount() {
        print("탈퇴하기 버튼 눌림")
    }
}



extension EditProfileViewController {
    
    func deleteAllPosts() {
        guard let profile = userProfile else {
            print("프로필 정보가 없습니다.")
            return
        }
        
        let postIDs = profile.posts
        guard !postIDs.isEmpty else {
            print("삭제할 포스트가 없습니다.")
            return
        }
        
        for postID in postIDs {
            PostNetworkManager.shared.deletePost(postID: postID) { result in
                switch result {
                case .success:
                    print("포스트 \(postID)가 성공적으로 삭제되었습니다.")
                case .failure(let error):
                    print("포스트 \(postID) 삭제 중 오류 발생: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // 내 프로필 가져오기
    func fetchUserProfile() {
        FollowPostNetworkManager.shared.fetchMyProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.userProfile = profile
                //   print("내 프로필 가져오는데 성공했어요🥰", profile)
                self?.updateUIWithProfileData()
            case .failure(let error):
                print("내 프로필 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }
    
    // 프로필 데이터를 기반으로 UI 업데이트
    private func updateUIWithProfileData() {
        guard let profile = userProfile else { return }
        
        // 팔로워, 팔로잉, 게시물 수 업데이트
        userNameLabel.text = profile.nick
        userEmailLabel.text = profile.email
        followersCountLabel?.text = "\(profile.followers.count)\n팔로워"
        followingCountLabel?.text = "\(profile.following.count)\n팔로잉"
        postsCountLabel?.text = "\(profile.posts.count)\n게시물수"
    }
}


