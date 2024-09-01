//
//  EditProfileUI.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit

struct EditProfileUI {
    
    static func profileImageButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "기본냥멍1"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor.systemGray2
        button.layer.cornerRadius = 40 // 버튼 크기의 절반 (80 / 2)
        button.layer.borderWidth = 3
        button.layer.borderColor = CustomColors.softPink.cgColor
        button.layer.masksToBounds = true
        
        return button
    }

    
    static func userNameLabel() -> UILabel {
        let label = UILabel()
        label.text = "홍길동"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }
    
    static func userEmailLabel() -> UILabel {
        let label = UILabel()
        label.text = "hongildong@email.address"
        label.textColor = UIColor.systemOrange
        return label
    }
    
    static func profileStatsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }
    
    static func notificationLabel() -> UILabel {
        let label = UILabel()
        label.text = "2.0 베타 버전이 완료되었습니다. 확인 부탁드립니다."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }
    
    static func logoutButton() -> UIButton {
        let button = UIButton()
        button.setTitle("게시글 초기화", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        return button
    }
    
    static func deleteAccountButton() -> UIButton {
        let button = UIButton()
        button.setTitle("탈퇴하기", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        return button
    }
    
    static func managePostsButton() -> UIButton {
        return button(withTitle: "좋아요한 게시글", backgroundColor: CustomColors.warmYellow)
    }
    
    static func editProfileButton() -> UIButton {
        return button(withTitle: "프로필 수정", backgroundColor: CustomColors.mintGreen)
    }
    
    static func viewFollowingButton() -> UIButton {
        return button(withTitle: "팔로잉 목록", backgroundColor: CustomColors.softCoral)
    }
    
    static func viewFollowersButton() -> UIButton {
        return button(withTitle: "팔로워 목록", backgroundColor: CustomColors.skyBlue)
    }
    
    static func buttonStackView(withButtons buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }
    
    
    static func button(withTitle title: String, backgroundColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.titleLabel?.numberOfLines = 2
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }
    
    static func statButton(number: String, title: String) -> UIButton {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "\(number)\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ])
        
        attributedTitle.append(NSAttributedString(string: title, attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.gray
        ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        
        return button
    }

    
    
    static func statLabel(number: String, title: String) -> UILabel {
        let label = UILabel()
        label.text = "\(number)\n\(title)"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }
    
    
    
}
