//
//  CommentTableViewCell.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/15/24.
//

import UIKit
import SnapKit

class CommentTableViewCell: UITableViewCell {
    
    // Profile Image View
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Username Label
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    // Date Label
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    // Comment Label
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    // Reply Button
    let replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("댓글달기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(replyButton)
    }
    
    private func configureConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
            make.width.height.equalTo(30)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(profileImageView.snp.right).offset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(usernameLabel.snp.right).offset(5)
            make.centerY.equalTo(usernameLabel)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
            make.left.equalTo(profileImageView.snp.right).offset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        replyButton.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(5)
            make.left.equalTo(commentLabel)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(with profileImage: UIImage?, username: String, date: String, comment: String) {
        profileImageView.image = profileImage
        usernameLabel.text = username
        dateLabel.text = date
        commentLabel.text = comment
    }
}
