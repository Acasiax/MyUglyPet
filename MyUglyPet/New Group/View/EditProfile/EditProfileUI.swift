//
//  EditProfileUI.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit

class EditProfileUI {
    static func profileImageButton() -> UIButton {
        let button = UIButton()
        // Configure your button here
        return button
    }

    static func userNameLabel() -> UILabel {
        let label = UILabel()
        // Configure your label here
        return label
    }

    static func userEmailLabel() -> UILabel {
        let label = UILabel()
        // Configure your label here
        return label
    }

    static func profileStatsStackView() -> UIStackView {
        let stackView = UIStackView()
        // Configure your stack view here
        return stackView
    }

    static func notificationLabel() -> UILabel {
        let label = UILabel()
        // Configure your label here
        return label
    }

    static func logoutButton() -> UIButton {
        let button = UIButton()
        // Configure your button here
        return button
    }

    static func deleteAccountButton() -> UIButton {
        let button = UIButton()
        // Configure your button here
        return button
    }

    static func managePostsButton() -> UIButton {
        let button = UIButton()
        // Configure your button here
        return button
    }

    static func editProfileButton() -> UIButton {
        let button = UIButton()
        // Configure your button here
        return button
    }

    static func viewFollowingButton() -> UIButton {
        let button = UIButton()
        // Configure your button here
        return button
    }

    static func viewFollowersButton() -> UIButton {
        let button = UIButton()
        // Configure your button here
        return button
    }

    static func buttonStackView(withButtons buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        // Configure your stack view here
        return stackView
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
}
