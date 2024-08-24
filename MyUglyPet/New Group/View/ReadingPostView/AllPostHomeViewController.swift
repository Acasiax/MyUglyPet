//
//  HomeViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/14/24.
//

import UIKit
import SnapKit
//import Kingfisher

// 델리게이트 프로토콜 정의
protocol AllPostTableViewCellDelegate: AnyObject {
    func didTapCommentButton(in cell: AllPostTableViewCell)
    func didTapDeleteButton(in cell: AllPostTableViewCell)
}

final class AllPostHomeViewController: UIViewController {
    
    private var serverPosts: [PostsModel] = []
    
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
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
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
        fetchPosts()
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
           // make.top.equalToSuperview().offset(20)
        }
        
        plusButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.bottom.right.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    
    //내 프로필 가져오기
    func fetchMyProfile() {
            // FollowPostNetworkManager 싱글턴 인스턴스를 사용하여 프로필 요청
            FollowPostNetworkManager.shared.fetchMyProfile { [weak self] result in
                switch result {
                case .success(let profile):
                    self?.myProfile = profile
                    print("내 프로필 가져오는데 성공했어요🥰", profile)
                   
                    
                case .failure(let error):
                    // 프로필 데이터를 가져오지 못했을 때
                    print("내 프로필 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
                }
            }
        }
    
    
    //게시글 모든 피드 가져오기
    private func fetchPosts() {
        // 쿼리 파라미터 생성

        let query = FetchReadingPostQuery(next: nil, limit: "30", product_id: "allFeed") //🌟

        // 네트워크 요청 예시 (PostNetworkManager 사용)
        PostNetworkManager.shared.fetchPosts(query: query) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.serverPosts = posts
                self?.tableView.reloadData() // 데이터 로드 후 테이블뷰 리로드
                print("포스팅을 가져오는데 성공했어요🥰")
            case .failure(let error):
                print("포스팅을 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }

    
    @objc private func plusButtonTapped() {
        print("게시글추가 +버튼 탭")
        AnimationZip.animateButtonPress(plusButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let postCreationVC = CreatePostViewController()
            self.navigationController?.pushViewController(postCreationVC, animated: true)
        }
    }
    

    // Pan Gesture 처리
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
//기능 지웠음
    }

    
    
    
}

extension AllPostHomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


extension AllPostHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print("헬로우 포스트 갯수: \(posts.count)")
        return serverPosts.count // 포스트 개수만큼 반환
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllPostTableViewCell.identifier, for: indexPath) as! AllPostTableViewCell
        
        let post = serverPosts[indexPath.row]
        cell.postID = post.postId
        cell.userID = post.creator.userId
        cell.titleLabel.text = post.title // 포스트 제목 설정
        cell.contentLabel.text = post.content // 포스트 내용 설정
        cell.imageFiles = post.files ?? [] // 이미지 URL 배열 전달
        cell.delegate = self  // 델리게이트 설정
        
        // 팔로우 상태를 확인하고 버튼을 설정
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
            
            detailViewController.title = selectedPost.title // 제목 설정
            detailViewController.post = selectedPost
            detailViewController.imageFiles = selectedPost.files ?? [] // 이미지 URL 배열 전달

            navigationController?.pushViewController(detailViewController, animated: true)
        }
}


// 델리게이트 메서드 구현
extension AllPostHomeViewController: AllPostTableViewCellDelegate {
    func didTapCommentButton(in cell: AllPostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let detailViewController = DetailViewController()
        detailViewController.title = "Post Detail \(indexPath.row + 1)"
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func didTapDeleteButton(in cell: AllPostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        // 서버에서 해당 포스트를 삭제한 후, 로컬 데이터에서도 삭제
        serverPosts.remove(at: indexPath.row)
        
        // 테이블뷰에서 셀 삭제
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}




class PostCollectionViewCell: UICollectionViewCell {

    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "기본냥멍2")
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    private func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


