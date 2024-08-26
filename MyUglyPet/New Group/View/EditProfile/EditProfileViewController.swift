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
    lazy var myLikedPostsButton = EditProfileUI.managePostsButton()
    lazy var editProfileButton = EditProfileUI.editProfileButton()
    lazy var viewFollowingButton = EditProfileUI.viewFollowingButton()
    lazy var viewFollowersButton = EditProfileUI.viewFollowersButton()
    lazy var buttonStackView = EditProfileUI.buttonStackView(withButtons: [
        myLikedPostsButton, editProfileButton, viewFollowingButton, viewFollowersButton
    ])
    
    private let disposeBag = DisposeBag()
    
    var followersButton = UIButton()
    var postsButton = UIButton()
    var followingButton = UIButton()
    
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
        followersButton = EditProfileUI.statButton(number: "0", title: "팔로워")
        postsButton = EditProfileUI.statButton(number: "0", title: "전체 게시물수")
        followingButton = EditProfileUI.statButton(number: "0", title: "팔로잉")
        
        profileStatsStackView.addArrangedSubview(followersButton)
        profileStatsStackView.addArrangedSubview(postsButton)
        profileStatsStackView.addArrangedSubview(followingButton)
        
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
        followersButton.rx.tap
            .bind(with: self) { owner, _ in
                AnimationZip.animateButtonPress(owner.followersButton)
                print("팔로워 버튼이 눌렸습니다.")
                owner.navigateToFollowers()
            }
            .disposed(by: disposeBag)
        
        postsButton.rx.tap
            .bind(with: self) { owner, _ in
                AnimationZip.animateButtonPress(owner.postsButton)
                print("전체 게시물수 버튼이 눌렸습니다.")
                owner.navigateToPosts()
            }
            .disposed(by: disposeBag)
        
        followingButton.rx.tap
            .bind(with: self) { owner, _ in
                AnimationZip.animateButtonPress(owner.followingButton)
                print("팔로잉 버튼이 눌렸습니다.")
                owner.navigateToFollowing()
            }
            .disposed(by: disposeBag)
        
        profileImageButton.rx.tap
            .bind(with: self) { owner, _ in
                AnimationZip.animateButtonPress(owner.profileImageButton)
                owner.handleProfileImageButtonTap()
            }
            .disposed(by: disposeBag)
        
        myLikedPostsButton.rx.tap
            .bind(with: self) { owner, _ in
                AnimationZip.animateButtonPress(owner.myLikedPostsButton)
                owner.MyLikedPostsButtonTap()
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
    
    private func MyLikedPostsButtonTap() {
        print("좋아요한 게시글 버튼이 눌렸습니다.")
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
                self?.updateUIWithProfileData()
            case .failure(let error):
                print("내 프로필 가져오는데 실패했어요!!: \(error.localizedDescription)")
            }
        }
    }
    
    // 프로필 데이터를 기반으로 UI 업데이트
    private func updateUIWithProfileData() {
        guard let profile = userProfile else { return }
        
        userNameLabel.text = profile.nick
        userEmailLabel.text = profile.email
        
        let followersTitle = "\(profile.followers.count)\n팔로워"
        let followingTitle = "\(profile.following.count)\n팔로잉"
        let postsTitle = "\(profile.posts.count)\n게시물수"
        
        followersButton.setAttributedTitle(EditProfileUI.statButton(number: "\(profile.followers.count)", title: "팔로워").attributedTitle(for: .normal), for: .normal)
        followingButton.setAttributedTitle(EditProfileUI.statButton(number: "\(profile.following.count)", title: "팔로잉").attributedTitle(for: .normal), for: .normal)
        postsButton.setAttributedTitle(EditProfileUI.statButton(number: "\(profile.posts.count)", title: "게시물수").attributedTitle(for: .normal), for: .normal)
    }
}

//MARK: - 화면 이동 함수
extension EditProfileViewController {
    private func navigateToFollowers() {
            let followersVC = FollowersViewController()
            navigationController?.pushViewController(followersVC, animated: true)
        }
        
        private func navigateToPosts() {
            let postsVC = PostsViewController()
            navigationController?.pushViewController(postsVC, animated: true)
        }
        
        private func navigateToFollowing() {
            let followingVC = HiViewController()
            followingVC.myProfile = self.userProfile
            navigationController?.pushViewController(followingVC, animated: true)
        }
}


