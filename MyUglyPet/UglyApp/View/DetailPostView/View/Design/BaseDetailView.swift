//
//  BaseDetailView.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/17/24.
//

import UIKit
import SnapKit

class BaseDetailView: UIViewController {
   
    lazy var userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "기본냥멍1")
        return imageView
    }()

    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "BLUE"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()

    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "4세 남아, 보더콜리"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    lazy var locationTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 동작구"
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

    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("수정", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        return button
    }()


    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "아침산책~~"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        return label
    }()


    // 구분선
    lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    // 댓글 없음 레이블
    lazy var noCommentsLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글이 없습니다."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.backgroundColor = CustomColors.lightBeige
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0  // 줄 간격
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DetailPhotoCollectionViewCell.self, forCellWithReuseIdentifier: DetailPhotoCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.isScrollEnabled = false // 스크롤 비활성화
        collectionView.backgroundColor = .yellow
        collectionView.layer.cornerRadius = 10 // 원하는 반지름 값으로 설정
        collectionView.clipsToBounds = true
        
       
        return collectionView
    }()
    
    // 댓글 입력 뷰
    lazy var commentInputView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.1)
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "댓글을 입력해주세요"
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        let sendImage = UIImage(systemName: "paperplane.fill")
        button.setImage(sendImage, for: .normal)
        button.tintColor = .systemBlue
        
        return button
    }()
    

   func configureHierarchy() {
        view.addSubview(userProfileImageView)
        view.addSubview(userNameLabel)
        view.addSubview(infoLabel)
        view.addSubview(locationTimeLabel)
        view.addSubview(timeLabel)
        view.addSubview(followButton)
        view.addSubview(collectionView)
        view.addSubview(contentLabel)

        view.addSubview(separatorLine)
        view.addSubview(noCommentsLabel)
        view.addSubview(tableView)
        view.addSubview(commentInputView)
        commentInputView.addSubview(commentTextField)
        commentInputView.addSubview(sendButton)
    }

     func configureConstraints() {
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
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.left.equalTo(userProfileImageView)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.lessThanOrEqualTo(80)
        }



        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1)
        }
        
        noCommentsLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(10)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(commentInputView.snp.top).offset(-10)
        }

        commentInputView.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
        

         commentTextField.snp.makeConstraints { make in
             make.top.bottom.equalTo(commentInputView)
             make.left.equalTo(commentInputView.snp.left).offset(5)
             make.right.equalTo(commentInputView.snp.right)
         }

        
        sendButton.snp.makeConstraints { make in
            make.right.equalTo(commentInputView).inset(10)
            make.centerY.equalTo(commentInputView)
            make.width.height.equalTo(24)
        }
    }
    
    

    
}
