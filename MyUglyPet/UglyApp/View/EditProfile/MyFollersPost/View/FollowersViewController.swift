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
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let viewModel = FollowersViewModel()
    private let disposeBag = DisposeBag()
    
    // 서버로부터 전달받은 데이터
    var myProfile: MyProfileResponse?
    

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





