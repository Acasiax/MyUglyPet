//
//  MyPostersViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyPostersViewController: UIViewController {
    
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
    
    var myProfile: MyProfileResponse? // 내 프로필에서 받은 값
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLatestPostData(userID: myProfile?.user_id ?? "d")
        print("가져온 유저 아이디 확인 : \(myProfile?.user_id ?? "유저 아이디 없음")")
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
    
//    // 내 프로필 가져오기
//    func fetchMyProfile() {
//        FollowPostNetworkManager.shared.fetchMyProfile { [weak self] result in
//            switch result {
//            case .success(let profile):
//                self?.myProfile = profile
//                self?.fetchLatestPostData(userID: profile.user_id)
//            case .failure(let error):
//                print("내 프로필 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
//            }
//        }
//    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        // 기능 지웠음
    }
}

extension MyPostersViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension MyPostersViewController: UITableViewDelegate, UITableViewDataSource {
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

extension MyPostersViewController: AllPostTableViewCellDelegate {
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

extension MyPostersViewController {
 
    // 특정 유저의 포스트 데이터 가져오기
    private func fetchLatestPostData(userID: String) {
        let query = FetchReadingPostQuery(next: nil, limit: "30", product_id: "allFeed")
        
        PostNetworkManager.shared.fetchUserPosts(userID: userID, query: query) { [weak self] result in
            switch result {
            case .success(let updatedPosts):
                print("특정 유저에서 가져온 포스트: \(updatedPosts)")
                self?.serverPosts = updatedPosts
                self?.tableView.reloadData()
            case .failure(let error):
                print("포스트 데이터를 불러오는 데 실패했습니다: \(error.localizedDescription)")
                self?.showAlert(title: "Error", message: "포스트 데이터를 불러오는 데 실패했습니다. 나중에 다시 시도해주세요.")
            }
        }
    }
    
    // showErrorAlert 대신 UIAlertController 사용
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
