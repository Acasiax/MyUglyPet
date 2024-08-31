//
//  AllPostTableViewCell.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/17/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class AllPostTableViewCell: BaseAllPostTableCell {
    
    weak var delegate: AllPostTableViewCellDelegate?
    private let disposeBag = DisposeBag()  // DisposeBag 수동 관리
   
    // 좋아요 버튼 상태를 저장할 변수
    var isPostLiked: Bool?
    
    // 서버에서 받은 좋아요 상태를 저장할 변수
    var serverLike: [String]? {
        didSet {
            updateLikeButton()
        }
    }
    
    // 각 셀의 포스트 ID를 저장하는 프로퍼티
    var postID: String?
    var userID: String? {
        didSet {
            checkAndHideButtons()
        }
    }
    
    var imageFiles: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var isFollowing = false
    private var isLiked = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         
        collectionView.dataSource = self
        collectionView.delegate = self
        
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    private func bindUI() {
        likeButton.rx.tap
                 .bind(with: self) { owner, _ in
                     guard let postID = owner.postID else {
                         print("포스트 ID가 없습니다.")
                         return
                     }
                     owner.toggleLikeButton()
                     // 좋아요 상태를 토글한 후, 서버에 요청
                     let newLikeStatus = !(owner.isPostLiked ?? false)
                     owner.likePost(postID: postID, likeStatus: newLikeStatus)
                 }
                 .disposed(by: disposeBag)
        
        followButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.followButtonTapped()
            }
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.deleteButtonTapped()
            }
            .disposed(by: disposeBag)
        
        commentButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.handleCommentButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
    private func toggleLikeButton() {
        isLiked.toggle()  // 상태를 토글

        // UI 업데이트
        let heartImage = isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likeButton.setImage(heartImage, for: .normal)
        likeButton.tintColor = isLiked ? .red : .black

        // 현재 상태를 출력
        if isLiked {
            print("좋아요가 눌렸습니다. 상태: 좋아요")
        } else {
            print("좋아요가 취소되었습니다. 상태: 좋아요 취소")
        }
    }
    

    private func updateLikeButtonUI() {
        let heartImage = isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likeButton.setImage(heartImage, for: .normal)
        likeButton.tintColor = isLiked ? .red : .black
    }
    
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
    
    
    
    func configureFollowButton(isFollowing: Bool) {
        self.isFollowing = isFollowing
        updateFollowButtonUI()
    }
    
    private func updateFollowButtonUI() {
        if isFollowing {
            followButton.setTitle("언팔로우", for: .normal)
            followButton.backgroundColor = .red
        } else {
            followButton.setTitle("팔로우", for: .normal)
            followButton.backgroundColor = .systemBlue
        }
    }
    
    private func handleCommentButtonTapped() {
        print("댓글 버튼 탭")
        delegate?.didTapCommentButton(in: self)
    }
    
    private func deleteButtonTapped() {
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
    
}

extension AllPostTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
        
        let imageURLString = imageFiles[indexPath.item]
        let fullImageURLString = APIKey.baseURL + "v1/" + imageURLString
        
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


//MARK: -  팔로우 언팔로우 기능
extension AllPostTableViewCell {
    
    private func followButtonTapped() {
        guard let myBuddyuserID = userID else {
            print("userID가 없습니다.")
            return
        }
        print("내가 친구하고 싶은 유저ID: \(myBuddyuserID)")
        
        isFollowing.toggle()
        updateFollowButtonUI()
        
        if isFollowing {
            followUser(userID: myBuddyuserID)
        } else {
            unfollowUser(userID: myBuddyuserID)
        }
    }
    
    private func followUser(userID: String) {
        FollowPostNetworkManager.shared.followUser(userID: userID) { [weak self] result in
            switch result {
            case .success:
                print("팔로우 성공")
            case .failure(let error):
                print("팔로우 실패: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.isFollowing.toggle()
                    self?.updateFollowButtonUI()
                }
            }
        }
    }
    
    private func unfollowUser(userID: String) {
        FollowPostNetworkManager.shared.unfollowUser(userID: userID) { [weak self] result in
            switch result {
            case .success:
                print("언팔로우 성공")
            case .failure(let error):
                print("언팔로우 실패: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.isFollowing.toggle()
                    self?.updateFollowButtonUI()
                }
            }
        }
    }
}






extension AllPostTableViewCell {
    
    //MARK: - 좋아요 상태 업데이트 하기
    private func updateLikeButton() {
        // serverLike 값 출력
        if let serverLike = serverLike {
            print("서버에서 받은 좋아요 상태: \(serverLike)")
            
            // 좋아요 상태가 있는지 확인하고 버튼 상태 업데이트
            if !serverLike.isEmpty {
                isLiked = true
                updateLikeButtonUI()
            } else {
                isLiked = false
                updateLikeButtonUI()
            }
        } else {
            print("serverLike 값이 없습니다.")
            isLiked = false
            updateLikeButtonUI()
        }
    }

    
    //MARK: - 게시물 좋아요 하기
    func likePost(postID: String, likeStatus: Bool) {
            PostNetworkManager.shared.likePost(postID: postID, likeStatus: likeStatus) { [weak self] result in
                
                switch result {
                case .success(let liked):
                    self?.isPostLiked = liked
                    print("포스트 좋아요 상태: \(liked)")
                    
                    // 추가로 UI 업데이트 등을 여기에 작성할 수 있습니다.
                    if liked {
                        print("포스트에 좋아요가 성공적으로 설정되었습니다.")
                    } else {
                        print("포스트에 대한 좋아요가 취소되었습니다.")
                    }

                case .failure(let error):
                    print("좋아요 요청 실패: \(error.localizedDescription)")
                    self?.isPostLiked = nil  // 요청이 실패했을 때, 상태를 nil로 설정하거나 적절히 처리
                }
            }
        }
    
    //MARK: - 삭제 하기
    private func deletePost(postID: String) {
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

extension AllPostTableViewCell {
    func configure(with post: PostsModel, myProfile: MyProfileResponse?, color: UIColor) {
        self.postID = post.postId
        self.userID = post.creator.userId
        self.userNameLabel.text = post.creator.nick
        self.postTitle.text = post.title
        self.titleLabel.text = post.title
        self.contentLabel.text = post.content
        self.imageFiles = post.files ?? []
        self.serverLike = post.likes
        self.containerView.backgroundColor = color

        if let myProfile = myProfile {
            let isFollowing = myProfile.following.contains(where: { $0.user_id == post.creator.userId })
            self.configureFollowButton(isFollowing: isFollowing)
        }
    }
}

