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
    private let viewModel = EditProfileViewModel()
    
    var followersButton = UIButton()
    var postsButton = UIButton()
    var followingButton = UIButton()
    
    var userProfile: MyProfileResponse?
    var serverUserID: String?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      fetchUserProfile()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.softIvory
        setupUI()
        bindViewModel()
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
    
    
    private func bindViewModel() {
        let input = EditProfileViewModel.Input(
            followersButtonTap: followersButton.rx.tap.asObservable(),
            postsButtonTap: postsButton.rx.tap.asObservable(),
            followingButtonTap: followingButton.rx.tap.asObservable(),
            profileImageButtonTap: profileImageButton.rx.tap.asObservable(),
            myLikedPostsButtonTap: myLikedPostsButton.rx.tap.asObservable(),
            editProfileButtonTap: editProfileButton.rx.tap.asObservable(),
            viewFollowingButtonTap: viewFollowingButton.rx.tap.asObservable(),
            viewFollowersButtonTap: viewFollowersButton.rx.tap.asObservable(),
            logoutButtonTap: logoutButton.rx.tap.asObservable(),
            deleteAccountButtonTap: deleteAccountButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.navigateToFollowers
            .drive(onNext: { [weak self] in
                self?.navigateToFollowers()
            })
            .disposed(by: disposeBag)
        
        output.navigateToPosts
            .drive(onNext: { [weak self] in
                self?.navigateToPosts()
            })
            .disposed(by: disposeBag)
        
        output.navigateToFollowing
            .drive(onNext: { [weak self] in
                self?.navigateToFollowing()
            })
            .disposed(by: disposeBag)
        
        output.showProfileImageOptions
            .drive(onNext: { [weak self] in
                self?.handleProfileImageButtonTap()
            })
            .disposed(by: disposeBag)
        
        output.navigateToMyLikedPosts
            .drive(onNext: { [weak self] in
                self?.MyLikedPostsButtonTap()
            })
            .disposed(by: disposeBag)
        
        output.navigateToEditProfile
            .drive(onNext: { [weak self] in
                self?.handleEditProfileButtonTap()
            })
            .disposed(by: disposeBag)
        
        output.navigateToViewFollowing
            .drive(onNext: { [weak self] in
                self?.handleViewFollowingButtonTap()
            })
            .disposed(by: disposeBag)
        
        output.navigateToViewFollowers
            .drive(onNext: { [weak self] in
                self?.handleViewFollowersButtonTap()
            })
            .disposed(by: disposeBag)
        
        output.performLogout
            .drive(onNext: { [weak self] in
                self?.handleLogout()
            })
            .disposed(by: disposeBag)
        
        output.performDeleteAccount
            .drive(onNext: { [weak self] in
                self?.deleteAccount()
            })
            .disposed(by: disposeBag)
    }
    
    
    
    // MARK: - 특정 사용자의 프로필 조회 및 UI 업데이트
       
       private func fetchOtherUserProfile() {
           guard let userID = serverUserID else {
               print("서버 사용자 ID가 없습니다.")
               return
           }

           print(userID)
           FollowPostNetworkManager.shared.fetchUserProfile(userID: userID) { [weak self] result in
               switch result {
               case .success(let profile):
                   self?.userProfile = profile
                   self?.updateUIWithProfileData()
                
               case .failure(let error):
                   print("다른 유저 프로필 가져오는데 실패했어요!!: \(error.localizedDescription)")
               }
           }
       }
    
    
    
    
    // MARK: - 내 프로필 조회랑, 조회 후 레이블 업데이트
    
    private func fetchUserProfile() {
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
    
    private func updateUIWithProfileData() {
        guard let profile = userProfile else { return }
        userNameLabel.text = profile.nick
        userEmailLabel.text = profile.email
        followersButton.setAttributedTitle(EditProfileUI.statButton(number: "\(profile.followers.count)", title: "팔로워").attributedTitle(for: .normal), for: .normal)
        followingButton.setAttributedTitle(EditProfileUI.statButton(number: "\(profile.following.count)", title: "팔로잉").attributedTitle(for: .normal), for: .normal)
        postsButton.setAttributedTitle(EditProfileUI.statButton(number: "\(profile.posts.count)", title: "내가 작성한\n게시물수").attributedTitle(for: .normal), for: .normal)
    }
    
    // MARK: - 모든 게시물 삭제 초기화
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
    
    
}

//MARK: - 위에 3개 화면 이동 함수
extension EditProfileViewController {
    //팔로워 화면(나를 추가한 친구들)
    private func navigateToFollowers() {
        let followersVC = FollowersViewController()
        followersVC.myProfile = self.userProfile
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    
    //🌟
    private func navigateToPosts() {
        let postsVC = MyPostersViewController()
        postsVC.myProfile = self.userProfile
        navigationController?.pushViewController(postsVC, animated: true)
    }
    
    //팔로잉 화면(내가 추가한 친구들)
    private func navigateToFollowing() {
        let followingVC = MyFollowingViewController()
        followingVC.myProfile = self.userProfile
       // print("🌟 \(followingVC.myProfile)")
        navigationController?.pushViewController(followingVC, animated: true)
    }
}

//MARK: - 이미지뷰 + 네모4개 버튼뷰 화면 이동 함수
extension EditProfileViewController {
    private func handleProfileImageButtonTap() {
        print("프로필 이미지 버튼이 눌렸습니다.")
    }
    
    private func MyLikedPostsButtonTap() {
        print("좋아요한 게시글 버튼이 눌렸습니다.")
        let postsVC = MyLikedPostsViewController()
        navigationController?.pushViewController(postsVC, animated: true)
    }
    
    private func handleEditProfileButtonTap() {
        print("프로필 수정 버튼이 눌렸습니다.")
        
    }
    
    private func handleViewFollowingButtonTap() {
        print("팔로잉 목록 버튼이 눌렸습니다.")
        let followingVC = MyFollowingViewController()
        followingVC.myProfile = self.userProfile
      //  print("🌟 \(followingVC.myProfile)")
        navigationController?.pushViewController(followingVC, animated: true)
    }
    
    private func handleViewFollowersButtonTap() {
        print("팔로워 목록 버튼이 눌렸습니다.")
        let followersVC = FollowersViewController()
        followersVC.myProfile = self.userProfile
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    private func handleLogout() {
        print("로그아웃 버튼 눌림")
        deleteAllPosts()
    }
    
    private func deleteAccount() {
        print("탈퇴하기 버튼 눌림")
    }
}
