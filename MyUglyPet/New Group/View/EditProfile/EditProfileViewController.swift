//
//  EditProfileViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit
import SnapKit

class EditProfileViewController: UIViewController {

    // MARK: - UI Components
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.systemGray2
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "홍길동"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "hongildong@email.address"
        label.textColor = UIColor.systemOrange
        return label
    }()
    
    private lazy var statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var alertLabel: UILabel = {
        let label = UILabel()
        label.text = "2.0 베타 버전이 완료되었습니다. 확인 부탁드립니다."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("설정", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        return button
    }()

    // Labels to be updated
    private var followersLabel: UILabel?
    private var postsLabel: UILabel?
    private var followingLabel: UILabel?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMyProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private var myProfile: MyProfileResponse?

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemGray6
        
        setupProfileArea()
        setupStatsArea()
        setupButtonsArea()
        setupBottomArea()
    }
    
    private func setupProfileArea() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        
        setupProfileAreaConstraints()
    }
    
    private func setupStatsArea() {
        followersLabel = labelUI(number: "0", title: "팔로워")
        postsLabel = labelUI(number: "0", title: "게시물수")
        followingLabel = labelUI(number: "0", title: "팔로잉")
        
        statsStackView.addArrangedSubview(followersLabel!)
        statsStackView.addArrangedSubview(postsLabel!)
        statsStackView.addArrangedSubview(followingLabel!)
        
        view.addSubview(statsStackView)
        
        setupStatsAreaConstraints()
    }

    private func setupButtonsArea() {
        let buttons = [
            buttonUI(title: "게시물 관리", iconName: "doc.text", action: #selector(handlePostManagement)),
            buttonUI(title: "새 글 쓰기", iconName: "pencil", action: #selector(handleNewPost)),
            buttonUI(title: "팔로잉 목록", iconName: "message", action: #selector(handleFollowing)),
            buttonUI(title: "팔로워 목록", iconName: "chart.bar", action: #selector(handleFollowers)),
            buttonUI(title: "프로필 관리", iconName: "person.circle", action: #selector(handleProfileManagement))
        ]
        
        buttons.forEach { buttonsStackView.addArrangedSubview($0) }
        view.addSubview(buttonsStackView)
        
        setupButtonsAreaConstraints()
    }
    
    private func setupBottomArea() {
        view.addSubview(alertLabel)
        view.addSubview(logoutButton)
        view.addSubview(settingsButton)
        
        setupBottomAreaConstraints()
    }

    // MARK: - Constraints Setup
    private func setupProfileAreaConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupStatsAreaConstraints() {
        statsStackView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func setupButtonsAreaConstraints() {
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(statsStackView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func setupBottomAreaConstraints() {
        alertLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonsStackView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(alertLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(alertLabel.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(20)
        }
    }

    // MARK: - Helper Methods
    private func labelUI(number: String, title: String) -> UILabel {
        let label = UILabel()
        label.text = "\(number)\n\(title)"
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }
    
    private func buttonUI(title: String, iconName: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.tintColor = .systemBlue
        button.imageView?.contentMode = .scaleAspectFit
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    // MARK: - Action Methods
    @objc private func handlePostManagement() {
        print("게시물 관리 버튼 눌림")
    }
    
    @objc private func handleNewPost() {
        print("새 글 쓰기 버튼 눌림")
    }
    
    @objc private func handleFollowing() {
        print("팔로잉 목록 버튼 눌림")
    }
    
    @objc private func handleFollowers() {
        print("팔로워 목록 버튼 눌림")
    }
    
    @objc private func handleProfileManagement() {
        print("프로필 관리 버튼 눌림")
    }
    
    @objc private func handleLogout() {
        print("로그아웃 버튼 눌림")
    }
    
    @objc private func handleSettings() {
        print("설정 버튼 눌림")
    }
}

extension EditProfileViewController {
    
    // 내 프로필 가져오기
    func fetchMyProfile() {
        FollowPostNetworkManager.shared.fetchMyProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.myProfile = profile
                print("내 프로필 가져오는데 성공했어요🥰", profile)
                self?.updateUIWithProfileData()
            case .failure(let error):
                print("내 프로필 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }

    // 프로필 데이터를 기반으로 UI 업데이트
    private func updateUIWithProfileData() {
        guard let profile = myProfile else { return }
        
        // 팔로워, 팔로잉, 게시물 수 업데이트
        followersLabel?.text = "\(profile.followers.count)\n팔로워"
        followingLabel?.text = "\(profile.following.count)\n팔로잉"
        postsLabel?.text = "\(profile.posts.count)\n게시물수"
    }
}
