//
//  PostsViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


//// 델리게이트 프로토콜 정의
//protocol AllPostTableViewCellDelegate: AnyObject {
//    func didTapCommentButton(in cell: AllPostTableViewCell)
//    func didTapDeleteButton(in cell: AllPostTableViewCell)
//}


final class MyLikedPostsViewController: UIViewController {
    
    private var serverPosts: [PostsModel] = []
    private let disposeBag = DisposeBag()
    
    let colors: [UIColor] = [
        CustomColors.deepPurple,
        UIColor(red: 1.00, green: 0.78, blue: 0.87, alpha: 1.00),
        UIColor(red: 0.73, green: 0.96, blue: 0.48, alpha: 1.00),
        CustomColors.softPink,
        CustomColors.softBlue,
        CustomColors.softPurple
    ]
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AllPostTableViewCell.self, forCellReuseIdentifier: AllPostTableViewCell.identifier)
        tableView.backgroundColor = CustomColors.lightBeige
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private var myProfile: MyProfileResponse?
    
    override func viewWillAppear(_ animated: Bool) {
        // 데이터 로드
      //  fetchPosts()
        fetchLikedPosts()
        fetchMyProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.83, green: 0.84, blue: 0.00, alpha: 1.00)
        view.addSubview(tableView)
        view.addSubview(plusButton)
        tableView.delegate = self
        tableView.dataSource = self
        configureConstraints()
        
        // Rx 방식으로 버튼 이벤트 처리
        plusButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.handlePlusButtonTap()
            }
            .disposed(by: disposeBag)
        
        // Pan Gesture Recognizer를 tableView에 추가
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture))
        panGestureRecognizer.delegate = self // 델리게이트 설정
        tableView.addGestureRecognizer(panGestureRecognizer)
    }
    
    deinit {
        print("AllPostHomeView 디이닛")
    }
    
    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.bottom.right.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func handlePlusButtonTap() {
        print("게시글추가 +버튼 탭")
        AnimationZip.animateButtonPress(plusButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let postCreationVC = CreatePostViewController()
            self.navigationController?.pushViewController(postCreationVC, animated: true)
        }
    }

    
    
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        // 기능 지웠음
    }
}



extension MyLikedPostsViewController{
    
    
    
    //좋아요한 포스트 가져오기
    func fetchLikedPosts() {
            let query = FetchLikedPostsQuery(next: nil, limit: "10") // 쿼리 설정 (next와 limit 값은 필요에 따라 설정)
            
            PostNetworkManager.shared.fetchLikedPosts(query: query) { [weak self] result in
                switch result {
                case .success(let posts):
                  //  self?.likedPosts = posts
                    self?.serverPosts = posts
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Failed to fetch liked posts: \(error.localizedDescription)")
                    // 에러 처리를 추가로 구현할 수 있습니다.
                }
            }
        }
    
    
    // 내 프로필 가져오기
    func fetchMyProfile() {
        FollowPostNetworkManager.shared.fetchMyProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.myProfile = profile
            case .failure(let error):
                print("내 프로필 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }
    
    // 게시글 모든 피드 가져오기
    private func fetchPosts() {
        let query = FetchReadingPostQuery(next: nil, limit: "30", product_id: "allFeed")
        
        PostNetworkManager.shared.fetchPosts(query: query) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.serverPosts = posts
                self?.tableView.reloadData()
            case .failure(let error):
                print("포스팅을 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }

    
    
}









extension MyLikedPostsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension MyLikedPostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllPostTableViewCell.identifier, for: indexPath) as! AllPostTableViewCell
        
        let post = serverPosts[indexPath.row]
        cell.postID = post.postId
        cell.userID = post.creator.userId
        cell.titleLabel.text = post.title
        cell.contentLabel.text = post.content
        cell.imageFiles = post.files ?? []
        cell.serverLike = post.likes
        cell.delegate = self
        
        if let myProfile = myProfile {
            let isFollowing = myProfile.following.contains(where: { $0.user_id == post.creator.userId })
            cell.configureFollowButton(isFollowing: isFollowing)
        }
        
        let colorIndex = indexPath.row % colors.count
        cell.containerView.backgroundColor = colors[colorIndex]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        let selectedPost = serverPosts[indexPath.row]
        
        detailViewController.post = selectedPost
        detailViewController.comments = selectedPost.comments
        detailViewController.imageFiles = selectedPost.files ?? []
        detailViewController.postId = selectedPost.postId
        
        if let firstComment = selectedPost.comments.first {
            detailViewController.commentId = firstComment.commentId
        } else {
            detailViewController.commentId = nil
        }
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension MyLikedPostsViewController: AllPostTableViewCellDelegate {
    func didTapCommentButton(in cell: AllPostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let detailViewController = DetailViewController()
        detailViewController.title = "Post Detail \(indexPath.row + 1)"
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func didTapDeleteButton(in cell: AllPostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        serverPosts.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
