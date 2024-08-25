//
//  CategoryCollectionViewCell.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/20/24.
//

import UIKit
import SnapKit


final class RankCollectionViewCell: UICollectionViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.softBlue
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        return view
    }()
    
    let profileImageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = CustomColors.softPurple
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "figure.stand")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.yellow
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.text = "1등"
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "꼬질이님"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "견생 5년차"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(profileImageContainerView)
        profileImageContainerView.addSubview(profileImageView)
        containerView.addSubview(rankLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rankLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(-10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageContainerView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        // 초기 cornerRadius 설정
        profileImageContainerView.layer.cornerRadius = 60 // 120의 절반
        profileImageView.layer.cornerRadius = 60 // 120의 절반
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    private func updateCornerRadius() {
        profileImageContainerView.layer.cornerRadius = profileImageContainerView.bounds.width / 2
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }
    
    func configure(with image: UIImage?, name: String, description: String, rank: String) {
        profileImageView.image = image
        nameLabel.text = name
        descriptionLabel.text = description
        rankLabel.text = rank
        
        // 레이아웃 업데이트 및 cornerRadius 재설정
        setNeedsLayout()
        layoutIfNeeded()
        updateCornerRadius()
    }
}




class BannerCollectionViewCell: UICollectionViewCell {

    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .green
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(imageView)
        imageView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with image: UIImage, title: String) {
        imageView.image = image
        titleLabel.text = title
    }
}

class MyBuddyCardCollectionViewCell: UICollectionViewCell {

    var postID: String?
    var userID: String?
    var imageFiles: [String] = [] // 이미지 파일 URL 배열
    weak var delegate: AnyObject? // 델리게이트

    private var isFollowing: Bool = false // 팔로우 상태를 추적하는 변수

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(named: "기본냥멍3")
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 2
        return label
    }()
    
    let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("팔로우", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(followButton)
        
        imageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(imageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalTo(followButton.snp.left).offset(-10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalTo(followButton.snp.left).offset(-10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        followButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
    }
    
    // 팔로우 상태를 설정하는 메서드 추가
    func configureFollowButton(isFollowing: Bool) {
        self.isFollowing = isFollowing
        updateFollowButtonUI()
    }

    private func updateFollowButtonUI() {
        if isFollowing {
            followButton.setTitle("언팔로우", for: .normal)
            followButton.backgroundColor = .green
        } else {
            followButton.setTitle("팔로우", for: .normal)
            followButton.backgroundColor = .orange
        }
    }

    @objc private func followButtonTapped() {
        guard let userID = userID else {
            print("userID가 없습니다.")
            return
        }

        isFollowing.toggle()
        updateFollowButtonUI()

        if isFollowing {
            FollowPostNetworkManager.shared.followUser(userID: userID) { [weak self] result in
                switch result {
                case .success:
                    print("팔로우 성공")
                case .failure(let error):
                    print("팔로우 실패: \(error.localizedDescription)")
                    // 팔로우 실패 시 UI를 원래대로 복구
                    DispatchQueue.main.async {
                        self?.isFollowing.toggle()
                        self?.updateFollowButtonUI()
                    }
                }
            }
        } else {
            FollowPostNetworkManager.shared.unfollowUser(userID: userID) { [weak self] result in
                switch result {
                case .success:
                    print("언팔로우 성공")
                case .failure(let error):
                    print("언팔로우 실패: \(error.localizedDescription)")
                    // 언팔로우 실패 시 UI를 원래대로 복구
                    DispatchQueue.main.async {
                        self?.isFollowing.toggle()
                        self?.updateFollowButtonUI()
                    }
                }
            }
        }
    }
    
    func configure(with image: UIImage, title: String, description: String) {
        imageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
