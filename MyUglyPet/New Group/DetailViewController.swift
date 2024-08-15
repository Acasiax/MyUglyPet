//
//  DetailViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/14/24.
//

import UIKit
import SnapKit


class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.circle")
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "BLUE"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .gray
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "4세 남아, 보더콜리"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.backgroundColor = .gray
        return label
    }()
    
    lazy var locationTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "경기도 고양시 일산서구"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        label.backgroundColor = .gray
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "1시간 전"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        label.backgroundColor = .gray
        return label
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("팔로우", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DetailPhotoCollectionViewCell.self, forCellWithReuseIdentifier: DetailPhotoCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .yellow
        return collectionView
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "아침산책~~"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.backgroundColor = .gray
        return label
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        let heartImage = UIImage(systemName: "heart")
        button.setImage(heartImage, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .green
        return button
    }()
    
    lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.backgroundColor = .gray
        return label
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        let commentImage = UIImage(systemName: "bubble.right")
        button.setImage(commentImage, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .green
        return button
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        configureHierarchy()
        configureConstraints()
    }
    
    private func configureHierarchy() {
        view.addSubview(userProfileImageView)
        view.addSubview(userNameLabel)
        view.addSubview(infoLabel)
        view.addSubview(locationTimeLabel)
        view.addSubview(timeLabel)
        view.addSubview(followButton)
        view.addSubview(collectionView)
        view.addSubview(contentLabel)
        view.addSubview(likeButton)
        view.addSubview(likeLabel)
        view.addSubview(commentButton)
        view.addSubview(commentLabel)
    }
    
    private func configureConstraints() {
        userProfileImageView.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.width.height.equalTo(40)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageView.snp.top)
            make.left.equalTo(userProfileImageView.snp.right).offset(20)
            make.right.lessThanOrEqualTo(followButton.snp.left).offset(-10)
            make.height.lessThanOrEqualTo(20)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.left.equalTo(userNameLabel)
            make.height.lessThanOrEqualTo(20)
        }
        
        locationTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(4)
            make.left.equalTo(userNameLabel)
            make.height.lessThanOrEqualTo(20)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationTimeLabel)
            make.left.equalTo(locationTimeLabel.snp.right).offset(8)
        }
        
        followButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(locationTimeLabel.snp.bottom).offset(10)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(200)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(4)
            make.left.equalTo(userProfileImageView)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.lessThanOrEqualTo(80)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.left.equalTo(contentLabel)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.left.equalTo(likeButton.snp.right).offset(5)
        }
        
        commentButton.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.left.equalTo(likeLabel.snp.right).offset(20)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(commentButton)
            make.left.equalTo(commentButton.snp.right).offset(5)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 // 테스트용으로 5개의 아이템 표시
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPhotoCollectionViewCell.identifier, for: indexPath) as! DetailPhotoCollectionViewCell
        // 셀 이미지 설정
        cell.imageView.image = UIImage(systemName: "lock.doc") // 예시 이미지
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

class DetailPhotoCollectionViewCell: UICollectionViewCell {
    

    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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


 
