//
//  DetailViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

final class DetailViewController: BaseDetailView {
    private let disposeBag = DisposeBag()
    
    var imageFiles: [String] = [] // 이미지 URL 배열
    var post: PostsModel? // 포스트 데이터
    
    var comments: [Comment] = []  // 댓글 배열
    var postId: String?
    var commentId: String?
    var userName: String?
    var titleText: String?
    var isFollowing: Bool = false
    
    private var serverPosts: [PostsModel] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
        updateUIWithPostData()
    }
    

    private func setupUI() {
        view.backgroundColor = CustomColors.lightBeige
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        configureHierarchy()
        configureConstraints()
    }
    
    private func setupRx() {
         followButton.rx.tap
             .bind(with: self) { owner, _ in
                 owner.handleFollowButtonTap()
             }
             .disposed(by: disposeBag)
         
         sendButton.rx.tap
             .bind(with: self) { owner, _ in
                 owner.handleSendButtonTap()
             }
             .disposed(by: disposeBag)
     }
    
 
    private func updateUIWithPostData() {
        guard let post = post else { return }
        
        contentLabel.text = post.content
        collectionView.reloadData()
        tableView.reloadData()
        
        if let userName = userName {
                    userNameLabel.text = userName
                }
        
        if let titleText = titleText {
            infoLabel.text = titleText
        }
        
        
        if let firstComment = post.comments.first {
            print("Comment ID (첫 번째 댓글): \(firstComment.commentId)")
        }
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
          
          postComment(toPostWithID: postID, content: text, userID: userID)
      }
      
      private func postComment(toPostWithID postID: String, content: String, userID: String) {
          PostNetworkManager.shared.postComment(toPostWithID: postID, content: content) { [weak self] result in
              switch result {
              case .success:
                  self?.fetchLatestPostData(userID: userID)
                  self?.commentTextField.text = ""
              case .failure(let error):
                  self?.showErrorAlert(message: "댓글 작성에 실패했습니다. 나중에 다시 시도해주세요. \(error.localizedDescription)")
              }
          }
      }
    
     func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
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
