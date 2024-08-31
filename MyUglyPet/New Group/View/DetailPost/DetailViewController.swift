//
//  DetailViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

// MARK: - ViewModel
final class DetailViewModel {
    
    struct Input {
        let followButtonTap: Observable<Void>
        let sendButtonTap: Observable<Void>
        let commentText: Observable<String?>
    }
    
    struct Output {
        let isFollowing: Driver<Bool>
        let postUpdated: Driver<PostsModel?>
        let errorMessage: Driver<String?>
    }
    
    private let disposeBag = DisposeBag()
    
    // Observable Properties
    private let isFollowingSubject = BehaviorSubject<Bool>(value: false)
    private let postUpdatedSubject = BehaviorSubject<PostsModel?>(value: nil)
    private let errorMessageSubject = PublishSubject<String?>()
    
    // Initialize with current post data
    init(initialPost: PostsModel?) {
        postUpdatedSubject.onNext(initialPost)
    }
    
    func transform(input: Input) -> Output {
        input.followButtonTap
            .withLatestFrom(isFollowingSubject)
            .map { !$0 }
            .bind(to: isFollowingSubject)
            .disposed(by: disposeBag)
        
        input.sendButtonTap
            .withLatestFrom(input.commentText)
            .compactMap { $0 }
            .withLatestFrom(postUpdatedSubject.compactMap { $0 }) { (commentText: $0, post: $1) }
            .flatMapLatest { [weak self] commentText, post in
                return self?.postComment(commentText, toPost: post) ?? .empty()
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let updatedPost):
                    self?.postUpdatedSubject.onNext(updatedPost)
                case .failure(let error):
                    self?.errorMessageSubject.onNext("댓글 작성에 실패했습니다. \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            isFollowing: isFollowingSubject.asDriver(onErrorJustReturn: false),
            postUpdated: postUpdatedSubject.asDriver(onErrorJustReturn: nil),
            errorMessage: errorMessageSubject.asDriver(onErrorJustReturn: nil)
        )
    }
    
    private func postComment(_ text: String, toPost post: PostsModel) -> Observable<Result<PostsModel, Error>> {
        return Observable.create { observer in
            PostNetworkManager.shared.postComment(toPostWithID: post.postId, content: text) { result in
                switch result {
                case .success:
                    observer.onNext(.success(post))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onNext(.failure(error))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

// MARK: - ViewController
final class DetailViewController: BaseDetailView {
    private let disposeBag = DisposeBag()
    private let viewModel: DetailViewModel
    
   
    var imageFiles: [String] = [] // 이미지 URL 배열
    var post: PostsModel? // 포스트 데이터
    var comments: [Comment] = []  // 댓글 배열
    var postId: String?
    var commentId: String?
    var isFollowing: Bool = false
    private var serverPosts: [PostsModel] = []
    
    // Initialize with a post model
    init(post: PostsModel) {
        self.viewModel = DetailViewModel(initialPost: post)
        super.init(nibName: nil, bundle: nil)
        self.post = post
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
        bindViewModel()
        updateUIWithPostData(post: post)
    }
    
    private func setupUI() {
        view.backgroundColor = CustomColors.lightBeige
        // Add and layout followButton, sendButton, and commentTextField
        // (layout code omitted for brevity)
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        configureHierarchy()
        configureConstraints()
    }
    
    private func setupRx() {
        // RxSwift bindings
    }
    
    private func bindViewModel() {
        let input = DetailViewModel.Input(
            followButtonTap: followButton.rx.tap.asObservable(),
            sendButtonTap: sendButton.rx.tap.asObservable(),
            commentText: commentTextField.rx.text.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isFollowing
            .drive(onNext: { [weak self] isFollowing in
                self?.updateFollowButton(isFollowing: isFollowing)
            })
            .disposed(by: disposeBag)
        
        output.postUpdated
            .drive(onNext: { [weak self] post in
                self?.updateUIWithPostData(post: post)
            })
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(onNext: { [weak self] errorMessage in
                if let message = errorMessage {
                    self?.showErrorAlert(message: message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateFollowButton(isFollowing: Bool) {
        let title = isFollowing ? "수정중" : "수정"
        let color = isFollowing ? CustomColors.softPink : UIColor.systemBlue
        followButton.setTitle(title, for: .normal)
        followButton.backgroundColor = color
    }
    
    private func updateUIWithPostData(post: PostsModel?) {
        guard let post = post else { return }
        contentLabel.text = post.content
        collectionView.reloadData()
        tableView.reloadData()
        
        if let firstComment = post.comments.first {
            print("Comment ID (첫 번째 댓글): \(firstComment.commentId)")
        }
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func handleFollowButtonTap() {
        toggleFollowState()
        animateFollowButton()
        presentEditPostViewController()
    }
    
    private func toggleFollowState() {
        isFollowing.toggle()
    }
    
    private func animateFollowButton() {
        let newTitle = isFollowing ? "수정중" : "수정"
        let newColor = isFollowing ? CustomColors.softPink : UIColor.systemBlue
        
        AnimationZip.animateButtonPress(followButton)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.followButton.setTitle(newTitle, for: .normal)
            self?.followButton.backgroundColor = newColor
        }
    }
    
    private func presentEditPostViewController() {
        let editVC = EditPostViewController()
        editVC.postTitle = post?.title
        editVC.postContent = post?.content
        editVC.onUpdate = { [weak self] updatedTitle, updatedContent in
            self?.post?.title = updatedTitle
            self?.post?.content = updatedContent
            self?.updatePost()
        }
        
        editVC.modalPresentationStyle = .overFullScreen
        editVC.modalTransitionStyle = .crossDissolve
        present(editVC, animated: true, completion: nil)
    }
    
    private func handleSendButtonTap() {
        guard let text = commentTextField.text, !text.isEmpty else { return }
        guard let postID = post?.postId, let userID = post?.creator.userId else {
            print("Post ID 또는 User ID를 찾을 수 없습니다.")
            return
        }
        
        PostNetworkManager.shared.postComment(toPostWithID: postID, content: text) { [weak self] result in
            switch result {
            case .success:
                self?.fetchLatestPostData(userID: userID)
                self?.commentTextField.text = ""
            case .failure(let error):
                self?.showErrorAlert(message: "댓글 작성에 실패했습니다. 나중에 다시 시도해주세요. \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - 사진 컬렉션뷰
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(imageFiles.count, 3)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPhotoCollectionViewCell.identifier, for: indexPath) as! DetailPhotoCollectionViewCell
        
        let imageURLString = imageFiles[indexPath.item]
        let fullImageURLString = APIKey.baseURL + "v1/" + imageURLString
        if let imageURL = URL(string: fullImageURLString) {
            cell.imageView.kf.setImage(
                with: imageURL,
                placeholder: UIImage(named: "pawprint"),
                options: [.requestModifier(AnyModifier { request in
                    var r = request
                    r.setValue(UserDefaultsManager.shared.token, forHTTPHeaderField: "Authorization")
                    r.setValue(APIKey.key, forHTTPHeaderField: "SesacKey")
                    return r
                })]
            )
        }
        
        if indexPath.item == 2 && imageFiles.count > 3 {
            let remainingCount = imageFiles.count - 2
            cell.configure(with: cell.imageView.image, overlayText: "+\(remainingCount)")
        } else {
            cell.configure(with: cell.imageView.image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let deepPhotoVC = DeepPhotoViewController()
        deepPhotoVC.photos = imageFiles.map { APIKey.baseURL + "v1/" + $0 }
        deepPhotoVC.selectedIndex = indexPath.item
        navigationController?.pushViewController(deepPhotoVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        
        let width: CGFloat
        if imageFiles.count == 1 {
            width = collectionViewWidth
        } else if imageFiles.count == 2 {
            width = collectionViewWidth / 2
        } else {
            width = collectionViewWidth / 3
        }
        
        return CGSize(width: width, height: 200)
    }
}

// MARK: - 댓글 테이블뷰 설정
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post?.comments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        cell.delegate = self
        
        if let comment = post?.comments[indexPath.row] {
            cell.configure(with: comment.creator.profileImage, username: comment.creator.nick, date: comment.createdAt, comment: comment.content)
        }
        
        return cell
    }
}

// MARK: - 댓글 딜리게이트 설정
extension DetailViewController: CommentTableViewCellDelegate {
    
    func didTapReplyButton(in cell: CommentTableViewCell, withContent content: String) {
        let editVC = EditCommentViewController()
        editVC.commentContent = content
        editVC.onUpdate = { [weak self] updatedContent in
            guard let indexPath = self?.tableView.indexPath(for: cell) else { return }
            self?.post?.comments[indexPath.row].content = updatedContent
            self?.editComment(commentId: self?.post?.comments[indexPath.row].commentId ?? "", newContent: updatedContent)
        }
        editVC.modalPresentationStyle = .overFullScreen
        editVC.modalTransitionStyle = .crossDissolve
        present(editVC, animated: true, completion: nil)
    }
    
    func didTapDeleteButton(in cell: CommentTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let postId = post?.postId,
              let commentId = post?.comments[indexPath.row].commentId else { return }
        
        deleteComment(postId: postId, commentId: commentId, at: indexPath)
    }
}

// MARK: - 서버 요청 관련 메서드
extension DetailViewController {
    
    func deleteComment(postId: String, commentId: String, at indexPath: IndexPath) {
        PostNetworkManager.shared.deleteComment(postID: postId, commentID: commentId) { [weak self] success, error in
            guard let self = self else { return }
            
            if success {
                self.post?.comments.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                self.showErrorAlert(message: "댓글을 삭제하는 데 실패했습니다. 나중에 다시 시도해주세요.")
            }
        }
    }
    
    func fetchLatestPostData(userID: String) {
        let query = FetchReadingPostQuery(next: nil, limit: "30", product_id: "allFeed")
        
        PostNetworkManager.shared.fetchUserPosts(userID: userID, query: query) { [weak self] result in
            switch result {
            case .success(let updatedPosts):
                self?.post = updatedPosts.first
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showErrorAlert(message: "포스트 데이터를 불러오는 데 실패했습니다. 나중에 다시 시도해주세요.")
            }
        }
    }
    
    func updatePost() {
        guard let postID = post?.postId else { return }
        
        let parameters: [String: Any] = [
            "title": post?.title ?? "",
            "content": post?.content ?? ""
        ]
        
        PostNetworkManager.shared.updatePost(postID: postID, parameters: parameters) { [weak self] result in
            switch result {
            case .success:
                self?.fetchLatestPostData(userID: self?.post?.creator.userId ?? "")
            case .failure(let error):
                self?.showErrorAlert(message: "포스트 수정에 실패했습니다. 나중에 다시 시도해주세요.")
            }
        }
    }
    
    func editComment(commentId: String, newContent: String) {
        guard let postID = post?.postId else { return }
        
        PostNetworkManager.shared.editComment(postID: postID, commentID: commentId, newContent: newContent) { [weak self] result in
            switch result {
            case .success:
                self?.fetchLatestPostData(userID: self?.post?.creator.userId ?? "")
            case .failure(let error):
                self?.showErrorAlert(message: "댓글 수정에 실패했습니다. 나중에 다시 시도해주세요.")
            }
        }
    }
}
