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


class HiViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentStackView = UIStackView()
    
    private var serverPosts: [PostsModel] = []
    private var myProfile: MyProfileResponse?
    
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

    // 취미 카드 섹션 헤더
    let hobbyCardHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "내 친구들"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    // 취미 카드 컬렉션 뷰
    let hobbyCardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 100)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MyBuddyCardCollectionViewCell.self, forCellWithReuseIdentifier: MyBuddyCardCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = CustomColors.softPurple
        return collectionView
    }()
    
    let disposeBag = DisposeBag()
    
    var rankedGroups: [(key: PostGroup, value: [PostsModel])] = []

    override func viewWillAppear(_ animated: Bool) {
        fetchHashtagPosts(hashTag: "1등이닷")
        fetchAllFeedPosts()
        fetchMyProfile()
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
        contentStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) // 좌측에 10pt 여백 추가
        
        // 로고 및 검색 버튼 추가
        let headerStackView = UIStackView(arrangedSubviews: [logoLabel, searchButton])
        headerStackView.axis = .horizontal
        headerStackView.spacing = 16
        contentStackView.addArrangedSubview(headerStackView)
        
       
        
        // 취미 카드 섹션 추가
        contentStackView.addArrangedSubview(hobbyCardHeaderLabel)
        contentStackView.addArrangedSubview(hobbyCardCollectionView)
    }
    
    func setupConstraints() {
        // ScrollView 제약 조건
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
      
        
        hobbyCardCollectionView.snp.makeConstraints { make in
            make.height.equalTo(400) // 필요 시 조정 가능
        }
    }
    
   
}



extension HiViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            
      
            
        case hobbyCardCollectionView:
            return serverPosts.count
            
        default:
            return 0
        }
    }
    
    func imageURLString(_ path: String) -> String {
        return path
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
      
            
        case hobbyCardCollectionView:
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBuddyCardCollectionViewCell.identifier, for: indexPath) as! MyBuddyCardCollectionViewCell
                  
                  let post = serverPosts[indexPath.row]
                  cell.postID = post.postId
                  cell.userID = post.creator.userId
                  cell.descriptionLabel.text = post.title // 포스트 제목 설정
                  cell.titleLabel.text = post.creator.nick // 사용자 닉네임
                  cell.imageFiles = post.files ?? [] // 이미지 URL 배열 전달
                  cell.delegate = self  // 델리게이트 설정
                  
                  // 팔로우 상태를 확인하고 버튼을 설정
                  if let myProfile = myProfile {
                      let isFollowing = myProfile.following.contains(where: { $0.user_id == post.creator.userId })
                      cell.configureFollowButton(isFollowing: isFollowing)
                  }
            
            // '나자신' 타이틀 설정을 위한 비교
               if let userID = cell.userID, userID == UserDefaultsManager.shared.id {
                   cell.followButton.setTitle("나자신", for: .normal)
                   cell.followButton.isEnabled = false // 자신의 계정을 팔로우하지 않도록 버튼 비활성화
                   cell.followButton.backgroundColor = .gray
               }
            
            cell.backgroundColor = CustomColors.softBlue
                  
                  return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
 
    
}


extension HiViewController {
    //내 프로필 가져오기
    func fetchMyProfile() {
            // FollowPostNetworkManager 싱글턴 인스턴스를 사용하여 프로필 요청
            FollowPostNetworkManager.shared.fetchMyProfile { [weak self] result in
                switch result {
                case .success(let profile):
                    self?.myProfile = profile
                   // print("내 프로필 가져오는데 성공했어요🥰", profile)
                   
                    
                case .failure(let error):
                    // 프로필 데이터를 가져오지 못했을 때
                    print("내 프로필 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
                }
            }
        }
    
    
    // 게시글 모든피드 포스팅 가져오기
    private func fetchAllFeedPosts() {
        print(#function)
      
        let query = FetchReadingPostQuery(next: nil, limit: "30", product_id: "allFeed") //🌟

        // 네트워크 요청 예시 (PostNetworkManager 사용)
        PostNetworkManager.shared.fetchPosts(query: query) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.serverPosts = posts
                self?.hobbyCardCollectionView.reloadData() // 데이터 로드 후 테이블뷰 리로드
                print("allFeed 포스팅을 가져오는데 성공했어요🥰")
            case .failure(let error):
                print("allFeed 포스팅을 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }
    
    
    // 해시태그를 사용하여 포스팅 가져오기
    private func fetchHashtagPosts(hashTag: String) {
        print(#function)
        let query = FetchHashtagReadingPostQuery(next: nil, limit: "30", product_id: "각유저가고른1등우승자", hashTag: hashTag)

        PostNetworkManager.shared.fetchHashtagPosts(query: query) { [weak self] result in
            switch result {
            case .success(let posts):
                
                // 모든 포스트 출력
             //   self?.printAllPosts(posts)
                // 포스트를 처리하여 랭킹 계산
                self?.processFetchedPosts(posts)
            case .failure(let error):
                print("해시태그로 포스팅을 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }

    // 모든 포스트를 출력
    private func printAllPosts(_ posts: [PostsModel]) {
        for (index, post) in posts.enumerated() {
            print("===== 포스트 \(index + 1) =====")
            print("포스트 타이틀: \(post.title ?? "제목 없음")")
            print("포스트 내용: \(post.content ?? "내용 없음")")
            print("포스트 내용1: \(post.content1 ?? "내용1 없음")")
            print("포스트 파일 URL들: \(post.files ?? [])")
            print("========================\n")
        }
    }

    // 가져온 포스트를 처리
    private func processFetchedPosts(_ posts: [PostsModel]) {
        print(#function)
        // 포스트를 그룹화하여 개수를 계산
        let groupedPosts = groupPosts(posts: posts)
        
        // 개수로 정렬하여 순위를 매김
        let rankedGroups = rankGroups(groupedPosts)
        
        // 모든 순위 출력
        displayRankedGroups(rankedGroups)
    }

    // 포스트를 그룹화하여 중복 개수 계산
    private func groupPosts(posts: [PostsModel]) -> [PostGroup: [PostsModel]] {
        var groupedPosts = [PostGroup: [PostsModel]]()
        
        for post in posts {
            let postGroup = PostGroup(
                title: post.title ?? "제목 없음",
                content: post.content ?? "내용 없음",
                content1: post.content1 ?? "내용1 없음"
            )
            
            groupedPosts[postGroup, default: []].append(post)
        }
        
        return groupedPosts
    }

    // 그룹화된 포스트를 개수로 정렬하여 순위를 매김
    private func rankGroups(_ groupedPosts: [PostGroup: [PostsModel]]) -> [(key: PostGroup, value: [PostsModel])] {
        return groupedPosts.sorted { $0.value.count > $1.value.count }
    }

    // 모든 순위 출력
    private func displayRankedGroups(_ rankedGroups: [(key: PostGroup, value: [PostsModel])]) {
        print(#function)
        guard !rankedGroups.isEmpty else {
            print("랭킹에 표시할 그룹이 없습니다.")
            return
        }
        
        for (index, group) in rankedGroups.enumerated() {
//            print("\(index + 1)등 그룹의 타이틀: \(group.key.title)")
//            print("\(index + 1)등 그룹의 내용: \(group.key.content)")
//            print("\(index + 1)등 그룹의 내용1: \(group.key.content1)")
//            print("\(index + 1)등 그룹의 중복된 포스트 개수: \(group.value.count)개")

            // 그룹에 포함된 포스트들을 모두 출력
            for (postIndex, post) in group.value.enumerated() {
               // print("    포함된 포스트 \(postIndex + 1): 타이틀: \(post.title ?? "제목 없음"), 파일 URL: \(post.files ?? [])")
            }
            
          //  print("========================\n")
        }
        
        self.rankedGroups = rankedGroups
      //  print("그룹이 잘 들어갔나?: \(rankedGroups)")
     
        
        
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
