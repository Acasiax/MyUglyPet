//
//  AllPostTableViewCell.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/17/24.
//

import UIKit
import SnapKit
import Kingfisher

final class AllPostTableViewCell: UITableViewCell {
    
    weak var delegate: AllPostTableViewCellDelegate?
    
    // UI 요소들
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .white // 컨테이너의 배경색 설정
        return view
    }()
    
    lazy var userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "기본냥멍1")
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "못난이"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "2세 남아, 푸들"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var locationTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 문래동"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "1시간 전"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("팔로우", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 10
        collectionView.clipsToBounds = true
        return collectionView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "우리집 강쥐 오늘 해피하게 뻗음"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        let heartImage = UIImage(systemName: "heart")
        button.setImage(heartImage, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        let commentImage = UIImage(systemName: "bubble.right")
        button.setImage(commentImage, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleCommentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    // 각 셀의 포스트 ID를 저장하는 프로퍼티
    var postID: String?
    var userID: String? {
        didSet {
            // userID가 설정될 때마다 followButton을 숨길지 여부를 확인
            checkAndHideButtons()
        }
    }
    
    var imageFiles: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // 팔로우 상태를 추적하는 변수
    private var isFollowing = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // contentView에 containerView 추가 및 UI 구성
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        configureHierarchy()
        configureConstraints()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        containerView.addSubview(userProfileImageView)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(infoLabel)
        containerView.addSubview(locationTimeLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(deleteButton)
        containerView.addSubview(followButton)
        containerView.addSubview(collectionView)
        containerView.addSubview(contentLabel)
        containerView.addSubview(likeButton)
        containerView.addSubview(likeLabel)
        containerView.addSubview(commentButton)
        containerView.addSubview(commentLabel)
    }
    
    private func configureConstraints() {
        userProfileImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
            make.width.height.equalTo(40)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(userProfileImageView.snp.right).offset(10)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.left.equalTo(userNameLabel)
        }
        
        locationTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(4)
            make.left.equalTo(userNameLabel)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(4)
            make.left.equalTo(locationTimeLabel.snp.right).offset(8)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        followButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.right.equalTo(deleteButton.snp.left).offset(-10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(locationTimeLabel.snp.bottom).offset(25)
            make.left.equalTo(userProfileImageView)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(200)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.left.equalTo(collectionView)
            make.bottom.equalToSuperview().inset(10)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.left.equalTo(likeButton.snp.right).offset(5)
        }
        
        commentButton.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.left.equalTo(likeLabel.snp.right).offset(20)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(commentButton)
            make.left.equalTo(commentButton.snp.right).offset(5)
        }
    }
    
    // followButton을 숨길지 여부를 확인하는 메서드
    private func checkAndHideButtons() {
        let currentUserID = UserDefaultsManager.shared.id
        if let userID = userID {
            followButton.isHidden = (userID == currentUserID)
            deleteButton.isHidden = (userID != currentUserID)
        } else {
            followButton.isHidden = false
            deleteButton.isHidden = true
        }
    }
    
    @objc func followButtonTapped() {
        guard let userID = userID else {
            print("userID가 없습니다.")
            return
        }
        
        // 팔로우 상태 토글
        isFollowing.toggle()
        updateFollowButtonUI()
        
        // 팔로우 또는 언팔로우 API 호출
        if isFollowing {
            FollowPostNetworkManager.shared.followUser(userID: userID) { [weak self] result in
                switch result {
                case .success:
                    print("팔로우 성공")
                case .failure(let error):
                    print("팔로우 실패: \(error.localizedDescription)")
                    // 실패 시 상태를 복구
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
                    // 실패 시 상태를 복구
                    DispatchQueue.main.async {
                        self?.isFollowing.toggle()
                        self?.updateFollowButtonUI()
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
    
    // 팔로우 버튼의 UI 업데이트
    private func updateFollowButtonUI() {
        if isFollowing {
            followButton.setTitle("언팔로우", for: .normal)
            followButton.backgroundColor = .red
        } else {
            followButton.setTitle("팔로우", for: .normal)
            followButton.backgroundColor = .systemBlue
        }
    }
    
    @objc private func handleCommentButtonTapped() {
        print("댓글 버튼 탭")
        delegate?.didTapCommentButton(in: self)
    }
    
    @objc func deleteButtonTapped() {
        guard let postID = postID else {
            print("postID가 없습니다.")
            return
        }
        
        isFollowing.toggle()
        AnimationZip.animateButtonPress(deleteButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            if self.isFollowing {
                self.deleteButton.setTitle("삭제완료", for: .normal)
                self.deleteButton.backgroundColor = .red
                self.deletePost(postID: postID)
            } else {
                self.deleteButton.setTitle("삭제", for: .normal)
                self.deleteButton.backgroundColor = .systemBlue
            }
        }
    }
    
    func deletePost(postID: String) {
        PostNetworkManager.shared.deletePost(postID: postID) { [weak self] result in
            switch result {
            case .success:
                print("포스트가 성공적으로 삭제되었습니다.")
                if let delegate = self?.delegate {
                    delegate.didTapDeleteButton(in: self!)
                }
            case .failure(let error):
                print("포스트 삭제 중 오류 발생: \(error.localizedDescription)")
            }
        }
    }
}


extension AllPostTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageFiles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
        
        let imageURLString = imageFiles[indexPath.item]
        let fullImageURLString = APIKey.baseURL + "v1/" + imageURLString //🌟내가 게시한 사진은 baseURL이 없음!
        
        if let imageURL = URL(string: fullImageURLString) {
            let headers = Router.fetchPosts(query: FetchReadingPostQuery(next: nil, limit: "10", product_id: "")).headersForImageRequest
            
            let modifier = AnyModifier { request in
                var r = request
                r.allHTTPHeaderFields = headers
                return r
            }
            
            cell.imageView.kf.setImage(
                with: imageURL,
                placeholder: UIImage(named: "placeholder"),
                options: [.requestModifier(modifier)]
            ) { result in
                switch result {
                case .success(let value):
                    print("이미지 로드 성공📩: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("이미지 로드 실패📩: \(error.localizedDescription)")
                }
            }
        } else {
            print("URL 변환에 실패했습니다📩: \(fullImageURLString)")
        }
        
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
