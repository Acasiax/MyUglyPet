//
//  AllPostTableViewCell.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import Foundation
import SnapKit

extension AllPostTableViewCell {
    
    func configureHierarchy() {
        containerView.addSubview(userProfileImageView)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(infoLabel)
        containerView.addSubview(locationTimeLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(deleteButton)
        containerView.addSubview(followButton)
        containerView.addSubview(collectionView)
        containerView.addSubview(contentLabel)
        containerView.addSubview(likeButton)
        containerView.addSubview(likeLabel)
        containerView.addSubview(commentButton)
        containerView.addSubview(commentLabel)
    }
    
    func configureConstraints() {
        userProfileImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
            make.width.height.equalTo(40)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(userProfileImageView.snp.right).offset(10)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.left.equalTo(userNameLabel)
        }
        
        locationTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(4)
            make.left.equalTo(userNameLabel)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(4)
            make.left.equalTo(locationTimeLabel.snp.right).offset(8)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        followButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.right.equalTo(deleteButton.snp.left).offset(-10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(locationTimeLabel.snp.bottom).offset(25)
            make.left.equalTo(userProfileImageView)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(200)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.left.equalTo(collectionView)
            make.bottom.equalToSuperview().inset(10)
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
    
    
}
