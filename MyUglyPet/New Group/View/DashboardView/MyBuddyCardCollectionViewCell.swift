//
//  HobbyCardCollectionViewCell.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/20/24.
//


import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MyBuddyCardCollectionViewCell: UICollectionViewCell {

    var postID: String?
    var userID: String?
    var imageFiles: [String] = [] // 이미지 파일 URL 배열
    weak var delegate: AnyObject? // 델리게이트

    private var isFollowing: Bool = false // 팔로우 상태를 추적하는 변수
    private let disposeBag = DisposeBag() // DisposeBag을 수동으로 관리

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
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindUI()
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

    private func bindUI() {
        followButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.handleFollowButtonTap()
            }
            .disposed(by: disposeBag)
    }
    
    private func handleFollowButtonTap() {
        guard let userID = userID else {
            print("userID가 없습니다.")
            return
        }

        isFollowing.toggle()
        updateFollowButtonUI()

        if isFollowing {
            FollowPostNetworkManager.shared.followUser(userID: userID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    print("팔로우 성공")
                case .failure(let error):
                    print("팔로우 실패: \(error.localizedDescription)")
                    // 팔로우 실패 시 UI를 원래대로 복구
                    DispatchQueue.main.async {
                        self.isFollowing.toggle()
                        self.updateFollowButtonUI()
                    }
                }
            }
        } else {
            FollowPostNetworkManager.shared.unfollowUser(userID: userID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    print("언팔로우 성공")
                case .failure(let error):
                    print("언팔로우 실패: \(error.localizedDescription)")
                    // 언팔로우 실패 시 UI를 원래대로 복구
                    DispatchQueue.main.async {
                        self.isFollowing.toggle()
                        self.updateFollowButtonUI()
                    }
                }
            }
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
    
    func configure(with image: UIImage, title: String, description: String) {
        imageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
