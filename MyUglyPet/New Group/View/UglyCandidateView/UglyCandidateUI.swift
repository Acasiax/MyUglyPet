//
//  UglyCandidateUI.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit
import SnapKit

struct UglyCandidateUI {

    static let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "후보를 등록해주세요"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    static let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.softPurple
        view.layer.cornerRadius = 20
        return view
    }()
    
    static let imageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "기본냥멍3"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 75
        button.clipsToBounds = true
        return button
    }()
    
    static let helloNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "사진제목"
        textField.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    static let subtitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "사용자이름"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.textColor = .gray
        return textField
    }()
    
    static let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("후보에 등록할게요", for: .normal)
        button.backgroundColor = CustomColors.softPink
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    

}

