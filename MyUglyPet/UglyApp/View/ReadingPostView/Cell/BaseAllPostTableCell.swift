//
//  BaseAllPostTableCell.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/31/24.
//

import UIKit
import SnapKit

class BaseAllPostTableCell: UITableViewCell {

    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    lazy var userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "기본냥멍1")
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "못난이"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    lazy var postTitle: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    lazy var locationTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 문래동"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "1시간 전"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return button
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
        collectionView.layer.cornerRadius = 10
        collectionView.clipsToBounds = true
        return collectionView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "우리집 강쥐 오늘 해피하게 뻗음"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        let heartImage = UIImage(systemName: "heart")
        button.setImage(heartImage, for: .normal)
        button.tintColor = .black
        return button
    }()
  
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        let commentImage = UIImage(systemName: "bubble.right")
        button.setImage(commentImage, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    
    // MARK: - 생성자
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 서브뷰랑 제약조건
    private func setupUI() {
        contentView.addSubview(containerView)
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(userProfileImageView)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(postTitle)
        containerView.addSubview(locationTimeLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(deleteButton)
        containerView.addSubview(followButton)
        containerView.addSubview(collectionView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)
        containerView.addSubview(likeButton)
        containerView.addSubview(commentButton)
      
    }
    
    private func setupConstraints() {
        
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        userProfileImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
            make.width.height.equalTo(40)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.left.equalTo(userProfileImageView.snp.right).offset(12)
            make.centerY.equalTo(userProfileImageView)
        }
        
        postTitle.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().inset(16)
        }
        
        locationTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(postTitle.snp.bottom).offset(4)
            make.left.equalTo(postTitle)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(locationTimeLabel)
            make.left.equalTo(locationTimeLabel.snp.right).offset(8)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        followButton.snp.makeConstraints { make in
            make.top.equalTo(deleteButton.snp.bottom).offset(8)
            make.right.equalTo(deleteButton)
            make.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(locationTimeLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(8)
            make.left.equalToSuperview().inset(16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    
        commentButton.snp.makeConstraints { make in
            make.left.equalTo(likeButton.snp.right).offset(16)
            make.centerY.equalTo(likeButton)
        }
        
      
    }
    
    private func registerCells() {
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
    }
}
