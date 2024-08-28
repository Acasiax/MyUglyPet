//
//  DashboardViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/20/24.
//
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

// 포스트 그룹을 정의하는 구조체 + 그룹화할때 3가지 조건이 맞으면 그룹화함
struct PostGroup: Hashable {
    let title: String
    let content: String
    let content1: String
}


// 서버에서 값을 받고 랭킹 셀에 넣을 구조체
struct finalPostGroup: Hashable {
    let title: String
    let content: String
    let content1: String
    let files: [String] // 파일 URL 배열을 저장
}


// 더미 데이터 배열
let bannerData: [(image: UIImage, title: String)] = [
    (image: UIImage(named: "기본냥멍1")!, title: "배너 제목 1"),
    (image: UIImage(named: "기본냥멍2")!, title: "배너 제목 2"),
    (image: UIImage(named: "기본냥멍3")!, title: "배너 제목 3")
]

class DashboardViewController: UIViewController {
    
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
    
    // 배너 섹션 헤더
    let bannerHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "배너"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    // 페이지 컨트롤 (배너가 사라졌으므로 이 부분도 제거할 수 있음)
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }()
    
    // 순위 섹션 헤더
    let rankHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "순위"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    // 순위 컬렉션 뷰
    let rankCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 160)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RankCollectionViewCell.self, forCellWithReuseIdentifier: RankCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = CustomColors.softPink
        return collectionView
    }()
    
    // 취미 카드 섹션 헤더
    let hobbyCardHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "게시글 작성한 친구들"
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
        
        rankCollectionView.dataSource = self
        hobbyCardCollectionView.dataSource = self
        
        rankCollectionView.delegate = self
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
        
        // 배너 섹션 추가 (배너 대신 CardCarouselViewController 추가)
        contentStackView.addArrangedSubview(bannerHeaderLabel)
        
        let cardCarouselVC = CardCarouselViewController()
        addChild(cardCarouselVC)
        contentStackView.addArrangedSubview(cardCarouselVC.view)
        cardCarouselVC.didMove(toParent: self)
        
        // 순위 섹션 추가
        contentStackView.addArrangedSubview(rankHeaderLabel)
        contentStackView.addArrangedSubview(rankCollectionView)
        
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
        
        // CardCarouselViewController의 view에 대한 제약 조건 설정
        let cardCarouselView = contentStackView.arrangedSubviews[2]
        cardCarouselView.snp.makeConstraints { make in
            //make.height.equalTo(view.snp.height).multipliedBy(0.3)
            make.height.equalTo(210)
        }
        
        rankCollectionView.snp.makeConstraints { make in
            make.height.equalTo(230)
        }
        
        hobbyCardCollectionView.snp.makeConstraints { make in
            make.height.equalTo(400) // 필요 시 조정 가능
        }
    }

}




extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            
        case rankCollectionView:
            print("👺\(rankedGroups.count)")
            return rankedGroups.count
            
            
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
    
            
        case rankCollectionView:
               guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankCollectionViewCell.identifier, for: indexPath) as? RankCollectionViewCell else {
                   return UICollectionViewCell()
               }

               let group = rankedGroups[indexPath.item]
               let rank = indexPath.item + 1

               // 셀의 기본 UI를 설정 (이미지 제외)
               cell.configure(
                   with: UIImage(systemName: "star"),  // 임시 또는 기본 이미지
                   name: " \(group.key.title)",
                   description: "\(group.key.content1)",
                   rank: "\(rank)등"
               )

               // 비동기적으로 이미지를 로드
               if let fileUrls = group.value.first?.files, let firstFileUrl = fileUrls.first {
                   let fullImageURLString = APIKey.baseURL + "v1/" + firstFileUrl
                   print("🙇‍♀️\(fullImageURLString)")

                   if let imageURL = URL(string: fullImageURLString) {
                       let headers: [String: String] = [
                           Header.sesacKey.rawValue: APIKey.key,
                           Header.authorization.rawValue: UserDefaultsManager.shared.token ?? ""
                       ]

                       let modifier = AnyModifier { request in
                           var r = request
                           r.allHTTPHeaderFields = headers
                           return r
                       }

                       cell.profileImageView.kf.setImage(
                           with: imageURL,
                           placeholder: UIImage(systemName: "photo"),  // 기본 placeholder 이미지
                           options: [.requestModifier(modifier)]
                       ) { result in
                           switch result {
                           case .success(let value):
                               print("이미지 로드 성공😊: \(value.source.url?.absoluteString ?? "")")
                               // 이미지 로드 성공 후, 셀의 UI를 다시 구성
                               cell.configure(
                                   with: value.image,  // 로드된 이미지로 업데이트
                                   name: " \(group.key.title)",
                                   description: "\(group.key.content1)",
                                   rank: "\(rank)등"
                               )

                           case .failure(let error):
                               print("이미지 로드 실패🥹: \(error.localizedDescription)")
                               // 실패 시 기본 이미지를 설정할 수도 있습니다.
                           }
                       }
                   } else {
                       print("URL 변환에 실패했습니다🥹: \(fullImageURLString)")
                   }
               }

               return cell
            
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


extension DashboardViewController {
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
                // 필터링 및 정렬 후, 중복된 사용자 게시물 처리
                self?.filterAndSortPostsByUserId()
                self?.hobbyCardCollectionView.reloadData() // 데이터 로드 후 컬렉션 뷰 리로드
                print("allFeed 포스팅을 가져오는데 성공했어요🥰")
            case .failure(let error):
                print("allFeed 포스팅을 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }

    private func filterAndSortPostsByUserId() {
        // 먼저 최신 포스트가 앞에 오도록 정렬
        serverPosts.sort { $0.createdAt > $1.createdAt }
        
        // Dictionary를 사용하여 중복된 userId를 제거하면서 최신 포스트만 유지
        var uniquePostsDict: [String: PostsModel] = [:]
        
        for post in serverPosts {
            let userId = post.creator.userId  // userId는 이제 String 타입입니다.
            
            // 만약 해당 userId가 이미 존재하지 않는다면 추가 (존재하면 추가하지 않음)
            if uniquePostsDict[userId] == nil {
                uniquePostsDict[userId] = post
            }
        }
        
        // 중복 제거된 게시물 배열을 생성
        serverPosts = Array(uniquePostsDict.values)
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
        rankCollectionView.reloadData()
        
        
    }
    
    
 
    
}


