//
//  FollowingViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class MyFollowingViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentStackView = UIStackView()
    
    var myProfile: MyProfileResponse?
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "냥멍난이"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        return button
    }()

    let hobbyCardHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "내 친구들"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let hobbyCardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 100)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HHiCollectionViewCell.self, forCellWithReuseIdentifier: HHiCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = CustomColors.softPurple
        return collectionView
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hobbyCardCollectionView.dataSource = self
        hobbyCardCollectionView.delegate = self
        
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        view.backgroundColor = CustomColors.lightBeige
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        let headerStackView = UIStackView(arrangedSubviews: [logoLabel, searchButton])
        headerStackView.axis = .horizontal
        headerStackView.spacing = 16
        contentStackView.addArrangedSubview(headerStackView)
        
        contentStackView.addArrangedSubview(hobbyCardHeaderLabel)
        contentStackView.addArrangedSubview(hobbyCardCollectionView)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        hobbyCardCollectionView.snp.makeConstraints { make in
            make.height.equalTo(400)
        }
    }
}

extension MyFollowingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myProfile?.following.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HHiCollectionViewCell.identifier, for: indexPath) as? HHiCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let followingUser = myProfile?.following[indexPath.row] {
            cell.userID = followingUser.user_id
            cell.nickNameLabel.text = followingUser.nick // 사용자 닉네임
            cell.emailLabel.text = myProfile?.email // 사용자 이메일
            
            // 프로필 이미지 설정
            if let profileImageURL = followingUser.profileImage {
                let url = URL(string: profileImageURL)
                cell.imageView.kf.setImage(with: url)
            } else {
                cell.imageView.image = UIImage(named: "기본냥멍3")
            }
            
            // 팔로우 버튼 설정 (이미 팔로우 상태로 가정)
            cell.configureFollowButton(isFollowing: true)
        }
        
        cell.backgroundColor = CustomColors.softBlue
        return cell
    }
}


class HHiCollectionViewCell: UICollectionViewCell {

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
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let emailLabel: UILabel = {
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
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(followButton)
        
        imageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(imageView.snp.height)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalTo(followButton.snp.left).offset(-10)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom)
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
        nickNameLabel.text = title
        emailLabel.text = description
    }
}
