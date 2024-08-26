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

class FollowersViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentStackView = UIStackView()
    
    var myProfile: MyProfileResponse?
    
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

    let hobbyCardHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "나를 추가한 친구들"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let hobbyCardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 100)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HHiCollectionViewCell.self, forCellWithReuseIdentifier: HHiCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = CustomColors.softPurple
        return collectionView
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetchAllFeedPosts() // 필요한 경우 추가적인 데이터를 가져오는 함수 호출
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
        contentStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        let headerStackView = UIStackView(arrangedSubviews: [logoLabel, searchButton])
        headerStackView.axis = .horizontal
        headerStackView.spacing = 16
        contentStackView.addArrangedSubview(headerStackView)
        
        contentStackView.addArrangedSubview(hobbyCardHeaderLabel)
        contentStackView.addArrangedSubview(hobbyCardCollectionView)
    }
    
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
}

extension FollowersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myProfile?.followers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HHiCollectionViewCell.identifier, for: indexPath) as? HHiCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let followerUser = myProfile?.followers[indexPath.row] {
            // 프린트 디버깅: myProfile 전체 값
            print("myProfile 전체 값: \(String(describing: myProfile))")
            
            cell.userID = followerUser.user_id
            cell.nickNameLabel.text = followerUser.nick
            cell.emailLabel.text = myProfile?.email

            // 프린트 디버깅: 각 셀의 닉네임과 이메일 값
            print("셀 \(indexPath.row)의 닉네임: \(String(describing: followerUser.nick))")
            print("셀 \(indexPath.row)의 이메일: \(String(describing: myProfile?.email))")
            
            // 프로필 이미지 설정
            if let profileImageURL = followerUser.profileImage {
                let url = URL(string: profileImageURL)
                cell.imageView.kf.setImage(with: url)
            } else {
                cell.imageView.image = UIImage(named: "기본냥멍3")
            }
            
            // 팔로우 버튼 설정 (이미 팔로우 상태로 가정)
            cell.configureFollowButton(isFollowing: true)
        }
        
        cell.backgroundColor = CustomColors.softBlue
        return cell
    }
}
