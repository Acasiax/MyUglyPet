//
//  FollowersViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

// MARK: - ViewModel
class FollowersViewModel {
    
    // Input: 사용자 상호작용을 정의
    struct Input {
        let fetchFollowers: Observable<MyProfileResponse?>
    }
    
    // Output: 처리 결과를 정의
    struct Output {
        let followers: Driver<[MyUser]>
        let error: Driver<String>
    }
    
    private let disposeBag = DisposeBag()
    
    // transform: Input을 받아 Output을 생성하는 메서드
    func transform(input: Input) -> Output {
        let followersRelay = BehaviorRelay<[MyUser]>(value: [])
        let errorRelay = PublishRelay<String>()
        
        input.fetchFollowers
            .compactMap { $0?.followers } // MyProfileResponse에서 followers를 추출
            .catch { error in
                errorRelay.accept("팔로워 데이터를 불러오는 중 에러가 발생했습니다.")
                return Observable.just([])
            }
            .bind(to: followersRelay)
            .disposed(by: disposeBag)
        
        return Output(
            followers: followersRelay.asDriver(),
            error: errorRelay.asDriver(onErrorJustReturn: "알 수 없는 오류가 발생했습니다.")
        )
    }
}

// MARK: - ViewController
class FollowersViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let viewModel = FollowersViewModel()
    private let disposeBag = DisposeBag()
    
    // 서버로부터 전달받은 데이터
    var myProfile: MyProfileResponse?
    
    // UI 컴포넌트 정의
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "냥멍난이"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    private let hobbyCardHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "나를 추가한 친구들"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let hobbyCardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 100)
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HHiCollectionViewCell.self, forCellWithReuseIdentifier: HHiCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = CustomColors.lightBeige
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupConstraints()
        bindViewModel()
    }
    
    // UI 구성 요소를 뷰에 추가하는 함수
    func setupSubviews() {
        view.backgroundColor = CustomColors.lightBeige
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        let headerStackView = UIStackView(arrangedSubviews: [logoLabel])
        headerStackView.axis = .horizontal
        headerStackView.spacing = 16
        contentStackView.addArrangedSubview(headerStackView)
        
        contentStackView.addArrangedSubview(hobbyCardHeaderLabel)
        contentStackView.addArrangedSubview(hobbyCardCollectionView)
    }
    
    // UI 구성 요소의 오토레이아웃 설정 함수
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        hobbyCardCollectionView.snp.makeConstraints { make in
            make.height.equalTo(400)
        }
    }
    
    // ViewModel과 View를 바인딩하는 함수
    func bindViewModel() {
        let input = FollowersViewModel.Input(
            fetchFollowers: Observable.just(myProfile)
        )
        
        let output = viewModel.transform(input: input)
        
        output.followers
            .drive(hobbyCardCollectionView.rx.items(cellIdentifier: HHiCollectionViewCell.identifier, cellType: HHiCollectionViewCell.self)) { index, follower, cell in
                cell.userID = follower.user_id
                cell.nickNameLabel.text = follower.nick
                cell.backgroundColor = CustomColors.softBlue
                
                if let profileImageURL = follower.profileImage {
                    let url = URL(string: profileImageURL)
                    cell.imageView.kf.setImage(with: url)
                } else {
                    cell.imageView.image = UIImage(named: "기본냥멍3")
                }
                
                cell.configureFollowButton(isFollowing: true)
            }
            .disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { errorMessage in
                // 에러 메시지를 처리할 수 있습니다.
                print(errorMessage)
            })
            .disposed(by: disposeBag)
    }
}



















//class FollowersViewController: UIViewController {
//    
//    let scrollView = UIScrollView()
//    let contentStackView = UIStackView()
//    
//    var myProfile: MyProfileResponse?
//    
//    let logoLabel: UILabel = {
//        let label = UILabel()
//        label.text = "냥멍난이"
//        label.font = UIFont.boldSystemFont(ofSize: 30)
//        return label
//    }()
//    
//    let searchButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
//        button.tintColor = .black
//        return button
//    }()
//
//    let hobbyCardHeaderLabel: UILabel = {
//        let label = UILabel()
//        label.text = "나를 추가한 친구들"
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        return label
//    }()
//    
//    let hobbyCardCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 100)
//        layout.minimumLineSpacing = 10
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(HHiCollectionViewCell.self, forCellWithReuseIdentifier: HHiCollectionViewCell.identifier)
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.backgroundColor = CustomColors.softPurple
//        return collectionView
//    }()
//    
//    let disposeBag = DisposeBag()
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //fetchAllFeedPosts() // 필요한 경우 추가적인 데이터를 가져오는 함수 호출
//    }
// 
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        hobbyCardCollectionView.dataSource = self
//        hobbyCardCollectionView.delegate = self
//        
//        setupSubviews()
//        setupConstraints()
//    }
//    
//    func setupSubviews() {
//        view.backgroundColor = CustomColors.lightBeige
//        
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentStackView)
//        
//        contentStackView.axis = .vertical
//        contentStackView.spacing = 16
//        contentStackView.isLayoutMarginsRelativeArrangement = true
//        contentStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//        
//        let headerStackView = UIStackView(arrangedSubviews: [logoLabel, searchButton])
//        headerStackView.axis = .horizontal
//        headerStackView.spacing = 16
//        contentStackView.addArrangedSubview(headerStackView)
//        
//        contentStackView.addArrangedSubview(hobbyCardHeaderLabel)
//        contentStackView.addArrangedSubview(hobbyCardCollectionView)
//    }
//    
//    func setupConstraints() {
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//        
//        contentStackView.snp.makeConstraints { make in
//            make.edges.equalTo(scrollView)
//            make.width.equalTo(scrollView)
//        }
//        
//        hobbyCardCollectionView.snp.makeConstraints { make in
//            make.height.equalTo(400)
//        }
//    }
//}
//
//extension FollowersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return myProfile?.followers.count ?? 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HHiCollectionViewCell.identifier, for: indexPath) as? HHiCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        
//        if let followerUser = myProfile?.followers[indexPath.row] {
//            // 프린트 디버깅: myProfile 전체 값
//            print("myProfile 전체 값: \(String(describing: myProfile))")
//            
//            cell.userID = followerUser.user_id
//            cell.nickNameLabel.text = followerUser.nick
//            cell.emailLabel.text = myProfile?.email
//   
//
//            // 프린트 디버깅: 각 셀의 닉네임과 이메일 값
//            print("셀 \(indexPath.row)의 닉네임: \(String(describing: followerUser.nick))")
//            print("셀 \(indexPath.row)의 이메일: \(String(describing: myProfile?.email))")
//            
//            // 프로필 이미지 설정
//            if let profileImageURL = followerUser.profileImage {
//                let url = URL(string: profileImageURL)
//                cell.imageView.kf.setImage(with: url)
//            } else {
//                cell.imageView.image = UIImage(named: "기본냥멍3")
//            }
//            
//            // 팔로우 버튼 설정 (이미 팔로우 상태로 가정)
//            cell.configureFollowButton(isFollowing: true)
//        }
//        
//        cell.backgroundColor = CustomColors.softBlue
//        return cell
//    }
//}
