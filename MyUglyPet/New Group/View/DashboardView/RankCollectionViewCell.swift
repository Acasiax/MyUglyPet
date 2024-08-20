//
//  CategoryCollectionViewCell.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/20/24.
//

import UIKit
import SnapKit

final class RankCollectionViewCell: UICollectionViewCell {

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.softBlue
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "figure.stand")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "꼬질이님"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "견생 5년차"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
            contentView.addSubview(containerView)
            containerView.addSubview(profileImageView)
            containerView.addSubview(nameLabel)
            containerView.addSubview(descriptionLabel)
            
            containerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            profileImageView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(80)
            }
            
            nameLabel.snp.makeConstraints { make in
                make.top.equalTo(profileImageView.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
            }
            
            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.centerX.equalToSuperview()
            }
        }
    
    func configure(with image: UIImage?, name: String, description: String) {
        profileImageView.image = image
        nameLabel.text = name
        descriptionLabel.text = description
    }
}
