//
//  EditProfileViewLayout.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit
import SnapKit

extension EditProfileViewController {
    
    func setupProfileSectionConstraints() {
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        userEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupStatsSectionConstraints() {
        profileStatsStackView.snp.makeConstraints { make in
            make.top.equalTo(userEmailLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    func setupBottomSectionConstraints() {
        let rowStackView1 = UIStackView(arrangedSubviews: [myLikedPostsButton, editProfileButton])
        rowStackView1.axis = .horizontal
        rowStackView1.distribution = .fillEqually
        rowStackView1.spacing = 10
        
        let rowStackView2 = UIStackView(arrangedSubviews: [viewFollowingButton, viewFollowersButton])
        rowStackView2.axis = .horizontal
        rowStackView2.distribution = .fillEqually
        rowStackView2.spacing = 10
        
        let buttonStackView = UIStackView(arrangedSubviews: [rowStackView1, rowStackView2])
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        
        view.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(profileStatsStackView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(80)
            make.height.equalTo(buttonStackView.snp.width)
        }
        
        notificationLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(notificationLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(notificationLabel.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(20)
        }
    }
    
}
