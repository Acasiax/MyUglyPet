//
//  DetailViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/14/24.
//

import UIKit
import SnapKit
import Kingfisher

struct DummyComment {
    let profileImage: UIImage?
    let username: String
    let date: String
    let text: String
}

struct UserComment {
    let profileImage: UIImage?
    let username: String
    let date: String
    let text: String
}


final class DetailViewController: BaseDetailView {
    
    var imageFiles: [String] = [] // 이미지 URL 배열을 저장할 프로퍼티
    var post: PostsModel? // 전달받은 포스트 데이터를 저장할 프로퍼티 //🔥
    
    var comments: [Comment] = []  // 댓글을 저장하는 배열
    var postId: String?
    var commentId: String?
    var isFollowing: Bool = false
    
    private var serverPosts: [PostsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CustomColors.lightBeige
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        configureHierarchy()
        configureConstraints()
        followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        // 전달받은 포스트 데이터를 UI에 반영
        if let post = post {
            contentLabel.text = post.content
            collectionView.reloadData()
            tableView.reloadData()
            // 추가적으로 titleLabel, userNameLabel 등에도 포스트 데이터를 반영할 수 있음
        }
        
        collectionView.reloadData() // 컬렉션뷰 리로드
        
        
        // 전달받은 postId와 commentId를 출력하거나 사용
//        if let postId = postId {
//            print("Post ID: \(postId)")
//        }
//        
//        if let commentId = commentId {
//            print("Comment ID: \(commentId)")
//        }
//        
        // post 객체에서 postId와 comments를 통해 Comment ID를 출력
        if let post = post {
            print("Post ID (post 객체): \(post.postId)")
            
            // 첫 번째 댓글의 Comment ID 출력
            if let firstComment = post.comments.first {
                print("Comment ID (첫 번째 댓글): \(firstComment.commentId)")
            }
        }
    }
    
    
    @objc func sendButtonTapped() {
        guard let text = commentTextField.text, !text.isEmpty else { return }

        guard let postID = post?.postId else {
            print("Post ID를 찾을 수 없습니다.")
            return
        }
        
        guard let userID = post?.creator.userId else {
               print("User ID를 찾을 수 없습니다.")
               return
           }
        
        print("사용할 Post ID: \(postID)")

        // 댓글 작성 요청을 보냅니다.
        PostNetworkManager.shared.postComment(toPostWithID: postID, content: text) { [weak self] result in
            switch result {
            case .success:
                print("댓글 작성 성공!")

                // 댓글 작성 후, 최신 포스트 데이터를 다시 불러옵니다.👍
                self?.fetchLatestPostData(userID: userID)

                // 텍스트 필드를 초기화합니다.
                self?.commentTextField.text = ""

            case .failure(let error):
                print("댓글 작성 실패: \(error.localizedDescription)")
                self?.showErrorAlert(message: "댓글 작성에 실패했습니다. 나중에 다시 시도해주세요.")
            }
        }
    }

    private func fetchLatestPostData(userID: String) {
        let query = FetchReadingPostQuery(next: nil, limit: "30", product_id: "allFeed")
        
        PostNetworkManager.shared.fetchUserPosts(userID: userID, query: query) { [weak self] result in
            switch result {
            case .success(let updatedPosts):
                print("🙌 특정유저별에서 가져온 값: \(updatedPosts)")
                // 최신 포스트 데이터를 가져오면, 이를 UI에 반영합니다.
                // 새로 받아온 첫 번째 포스트를 기존 post 객체에 업데이트
                self?.post = updatedPosts.first // 필요한 경우 로직을 조정하세요
                self?.tableView.reloadData() // 테이블뷰를 리로드하여 최신 포스트가 반영되도록 합니다.

            case .failure(let error):
                print("포스트 데이터를 불러오는 데 실패했습니다: \(error.localizedDescription)")
                self?.showErrorAlert(message: "포스트 데이터를 불러오는 데 실패했습니다. 나중에 다시 시도해주세요.")
            }
        }
    }




    @objc func followButtonTapped() {
        print("팔로우 버튼 탭")
        
        // 현재 상태에 따라 버튼 제목과 배경색을 토글
        isFollowing.toggle()
        
        let newTitle = isFollowing ? "수정중" : "수정"
        let newColor = isFollowing ? UIColor.orange : UIColor.systemBlue
        
        // 애니메이션 적용
        AnimationZip.animateButtonPress(followButton)
        
        // 버튼의 제목과 배경색을 변경
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.followButton.setTitle(newTitle, for: .normal)
            self.followButton.backgroundColor = newColor
        }
    }
    
}


//사진 컬렉션뷰
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageFiles.count <= 2 {
            return imageFiles.count
        } else {
            return 3
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPhotoCollectionViewCell.identifier, for: indexPath) as! DetailPhotoCollectionViewCell
        
        // 이미지 URL을 가져옴
        let imageURLString = imageFiles[indexPath.item]
        let fullImageURLString = APIKey.baseURL + "v1/" + imageURLString
        print("이미지스트링: \(fullImageURLString)")
        if let imageURL = URL(string: fullImageURLString) {
            // Kingfisher를 사용하여 이미지를 비동기로 로드
            cell.imageView.kf.setImage(
                with: imageURL,
                placeholder: UIImage(named: "placeholder"),
                options: [.requestModifier(AnyModifier { request in
                    var r = request
                    r.setValue(UserDefaultsManager.shared.token, forHTTPHeaderField: "Authorization")
                    r.setValue(APIKey.key, forHTTPHeaderField: "SesacKey")
                    return r
                })]
            ) { result in
                switch result {
                case .success(let value):
                    print("이미지 로드 성공📍: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("이미지 로드 실패📍: \(error.localizedDescription)")
                }
            }
        } else {
            print("URL 변환에 실패했습니다: \(fullImageURLString)")
        }
        
        // 이미지 파일 수에 따른 추가 설정
        if indexPath.item < 2 {
            // 첫 두 개의 이미지 설정
            cell.configure(with: cell.imageView.image)
        } else if indexPath.item == 2 && imageFiles.count > 2 {
            // 남은 이미지 개수 표시
            let remainingCount = imageFiles.count - 2
            cell.configure(with: cell.imageView.image, overlayText: "+\(remainingCount)")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("따르릉릉🤚🏻")
        let deepPhotoVC = DeepPhotoViewController()
        
        // 이미지 파일의 전체 URL을 생성하여 deepPhotoVC에 전달
        deepPhotoVC.photos = imageFiles.map { file in
            return APIKey.baseURL + "v1/" + file
        }
   
        // 선택한 인덱스를 deepPhotoVC에 전달
        deepPhotoVC.selectedIndex = indexPath.item
        
        // deepPhotoVC로 화면 전환
        navigationController?.pushViewController(deepPhotoVC, animated: true)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        
        if imageFiles.count == 1 {
            // 이미지가 1개일 때는 전체 컬렉션뷰의 너비를 사용
            return CGSize(width: collectionViewWidth, height: 200)
        } else if imageFiles.count == 2 {
            // 이미지가 2개일 때는 각각 절반 너비를 사용
            return CGSize(width: collectionViewWidth / 2, height: 200)
        } else {
            // 이미지가 3개 이상일 때는 기본 크기를 사용
            return CGSize(width: collectionViewWidth / 3, height: 200)
        }
    }
}


//댓글 창 테이블뷰
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // post가 nil이 아니고, 댓글이 있으면 그 수를 반환, 그렇지 않으면 0을 반환
        return post?.comments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        cell.delegate = self
        
        // post의 comments 배열에서 해당 댓글을 가져옴
        if let comment = post?.comments[indexPath.row] {
            // 각 속성을 설정하여 셀을 구성
            cell.configure(with: comment.creator.profileImage, username: comment.creator.nick, date: comment.createdAt, comment: comment.content)
        }
        
        return cell
    }
}


//extension DetailViewController: CommentTableViewCellDelegate {
//    func didTapDeleteButton(in cell: CommentTableViewCell) {
//        // 여기에서 삭제 버튼이 눌렸을 때의 동작을 정의합니다.
//        print("삭제 버튼이 DetailViewController에서 눌렸습니다.")
//        
//        // 예를 들어, 해당 셀의 인덱스를 가져와 해당 댓글을 삭제할 수 있습니다.
//        if let indexPath = tableView.indexPath(for: cell) {
//            // comments 배열에서 해당 댓글을 삭제
//            comments.remove(at: indexPath.row)
//            // 테이블뷰에서 해당 셀 삭제
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
//}



extension DetailViewController: CommentTableViewCellDelegate {
    func didTapDeleteButton(in cell: CommentTableViewCell) {
        print("삭제 버튼이 DetailViewController에서 눌렸습니다.")
        
        // 해당 셀의 인덱스를 가져옴
        if let indexPath = tableView.indexPath(for: cell) {
            
            guard let postId = post?.postId else {
                print("오류: postId가 nil입니다. 댓글 삭제 요청을 중단합니다.")
                return
            }
            
            let commentId = post?.comments[indexPath.row].commentId
            
            guard let commentId = commentId else {
                print("오류: commentId가 nil입니다. 댓글 삭제 요청을 중단합니다.")
                return
            }
            
            print("삭제할 댓글 정보:")
            print(" - postId: \(postId)")
            print(" - commentId: \(commentId)")
            print(" - 해당 셀의 인덱스: \(indexPath.row)")
            
            // 네트워크를 통해 댓글 삭제 요청
            PostNetworkManager.shared.deleteComment(postID: postId, commentID: commentId) { [weak self] success, error in
                guard let self = self else {
                    print("오류: DetailViewController 인스턴스가 nil입니다. 클로저 실행 중단.")
                    return
                }
                
                if success {
                    print("서버로부터 댓글 삭제 성공 응답을 받았습니다.")
                    
                    // 테이블뷰 업데이트 전에 comments 배열에서 해당 댓글 삭제
                    self.post?.comments.remove(at: indexPath.row)
                    
                    // 테이블뷰에서 해당 셀 삭제
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                    print("댓글이 성공적으로 삭제되었습니다.")
                    
                } else {
                    if let error = error {
                        print("댓글 삭제 실패: \(error.localizedDescription)")
                    } else {
                        print("댓글 삭제 실패: 알 수 없는 오류 발생")
                    }
                    
                    // 오류 메시지를 사용자에게 표시
                    self.showErrorAlert(message: "댓글을 삭제하는 데 실패했습니다. 나중에 다시 시도해주세요.")
                }
            }
        } else {
            print("오류: 셀의 인덱스를 가져오지 못했습니다. 댓글 삭제 요청을 중단합니다.")
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}




