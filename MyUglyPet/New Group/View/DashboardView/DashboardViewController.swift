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
   // let files: String
    // files는 비교에서 제외됩니다.
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
    
    // 배너 컬렉션 뷰
    let bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 150)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // 페이지 컨트롤
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
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
        label.text = "취미 카드"
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
        collectionView.register(HobbyCardCollectionViewCell.self, forCellWithReuseIdentifier: HobbyCardCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = CustomColors.softPurple
        return collectionView
    }()
    
    
    var rankedGroups: [(key: PostGroup, value: [PostsModel])] = []

    override func viewWillAppear(_ animated: Bool) {
        fetchHashtagPosts(hashTag: "1등이닷")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.dataSource = self
        rankCollectionView.dataSource = self
        hobbyCardCollectionView.dataSource = self
        
        bannerCollectionView.delegate = self
        rankCollectionView.delegate = self
        hobbyCardCollectionView.delegate = self
        
        // 배너의 페이지 수에 맞춰 페이지 컨트롤 설정
        pageControl.numberOfPages = bannerData.count
        
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
        
        // 배너 섹션 추가
        contentStackView.addArrangedSubview(bannerHeaderLabel)
        contentStackView.addArrangedSubview(bannerCollectionView)
        contentStackView.addArrangedSubview(pageControl)
        
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
        
        bannerCollectionView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
        
        rankCollectionView.snp.makeConstraints { make in
            make.height.equalTo(230)
        }
        
        hobbyCardCollectionView.snp.makeConstraints { make in
            make.height.equalTo(400) // 필요 시 조정 가능
        }
    }
    
    // 페이지 컨트롤 값 변경 시 호출되는 메서드
    @objc func pageControlValueChanged(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}




extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            
        case bannerCollectionView:
            return bannerData.count
            
        case rankCollectionView:
            print("👺\(rankedGroups.count)")
            return rankedGroups.count
            
            
        case hobbyCardCollectionView:
            return 10
            
        default:
            return 0
        }
    }
    
    func imageURLString(_ path: String) -> String {
        return path
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case bannerCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as! BannerCollectionViewCell
            let data = bannerData[indexPath.item]
            cell.configure(with: data.image, title: data.title)
            return cell
            
        case rankCollectionView:
                   guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankCollectionViewCell.identifier, for: indexPath) as? RankCollectionViewCell else {
                       return UICollectionViewCell()
                   }

                   let group = rankedGroups[indexPath.item]
                   let rank = indexPath.item + 1
                   
                   if let fileUrls = group.value.first?.files, let firstFileUrl = fileUrls.first {
                       let fullImageURLString = APIKey.baseURL + "v1/" + firstFileUrl

                       
                       print("🙇‍♀️\(fullImageURLString)")
                       
                       if let imageURL = URL(string: fullImageURLString) {
                           // 헤더 설정
                           let headers: [String: String] = [
                               Header.sesacKey.rawValue: APIKey.key,
                               Header.authorization.rawValue: UserDefaultsManager.shared.token ?? ""
                           ]
                           
                           // Kingfisher의 AnyModifier를 사용하여 요청 수정
                           let modifier = AnyModifier { request in
                               var r = request
                               r.allHTTPHeaderFields = headers
                               return r
                           }
                           
                           cell.profileImageView.kf.setImage(
                               with: imageURL,
                               placeholder: UIImage(systemName: "photo"), // 기본 placeholder 이미지
                               options: [.requestModifier(modifier)]
                           ) { result in
                               switch result {
                               case .success(let value):
                                   print("이미지 로드 성공🥹: \(value.source.url?.absoluteString ?? "")")
                               case .failure(let error):
                                   print("이미지 로드 실패🥹: \(error.localizedDescription)")
                               }
                           }
                       } else {
                           print("URL 변환에 실패했습니다🥹: \(fullImageURLString)")
                       }
                   }
                   
            cell.configure(with: UIImage(systemName: "star"), name: " \(group.key.title)", description: "\(group.key.content1)", rank: "\(rank)등")
                   
                   return cell
            
        case hobbyCardCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HobbyCardCollectionViewCell.identifier, for: indexPath) as! HobbyCardCollectionViewCell
            cell.configure(with: UIImage(named: "기본냥멍1")!, title: "유저 \(indexPath.row + 1)", description: "이것은 취미 카드 설명입니다.")
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            let page = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            pageControl.currentPage = page
        }
    }
}


extension DashboardViewController {

    // 해시태그를 사용하여 포스팅 가져오기
    private func fetchHashtagPosts(hashTag: String) {
        let query = FetchHashtagReadingPostQuery(next: nil, limit: "30", product_id: "각유저가고른1등우승자", hashTag: hashTag)

        PostNetworkManager.shared.fetchHashtagPosts(query: query) { [weak self] result in
            switch result {
            case .success(let posts):
                // 모든 포스트 출력
                self?.printAllPosts(posts)
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
        guard !rankedGroups.isEmpty else {
            print("랭킹에 표시할 그룹이 없습니다.")
            return
        }
        
        for (index, group) in rankedGroups.enumerated() {
            print("\(index + 1)등 그룹의 타이틀: \(group.key.title)")
            print("\(index + 1)등 그룹의 내용: \(group.key.content)")
            print("\(index + 1)등 그룹의 내용1: \(group.key.content1)")
            print("\(index + 1)등 그룹의 중복된 포스트 개수: \(group.value.count)개") // 해당 그룹에 몇 개의 포스트가 있는지 출력

            // 그룹에 포함된 포스트들을 모두 출력
            for (postIndex, post) in group.value.enumerated() {
                print("    포함된 포스트 \(postIndex + 1): 타이틀: \(post.title ?? "제목 없음"), 파일 URL: \(post.files ?? [])")
            }
            
            print("========================\n")
        }
        
        self.rankedGroups = rankedGroups
        print("그룹이 잘 들어갔나?: \(rankedGroups)")
        rankCollectionView.reloadData()
        
        
    }
    
    
 
    
}


final class RankCollectionViewCell: UICollectionViewCell {

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.softBlue
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "figure.stand")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75 // Half of the height/width for a circular view
        return imageView
    }()
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.yellow
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.text = "1등"
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "꼬질이님"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "견생 5년차"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(rankLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        rankLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(-10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }
    
    func configure(with image: UIImage?, name: String, description: String, rank: String) {
        profileImageView.image = image
        nameLabel.text = name
        descriptionLabel.text = description
        rankLabel.text = rank
    }
}










