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
    
    let profileImageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = CustomColors.softPurple
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "figure.stand")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.yellow
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.text = "1등"
        return label
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
        containerView.addSubview(profileImageContainerView)
        profileImageContainerView.addSubview(profileImageView)
        containerView.addSubview(rankLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rankLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(-10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageContainerView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        // 초기 cornerRadius 설정
        profileImageContainerView.layer.cornerRadius = 60 // 120의 절반
        profileImageView.layer.cornerRadius = 60 // 120의 절반
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    private func updateCornerRadius() {
        profileImageContainerView.layer.cornerRadius = profileImageContainerView.bounds.width / 2
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }
    
    func configure(with image: UIImage?, name: String, description: String, rank: String) {
        profileImageView.image = image
        nameLabel.text = name
        descriptionLabel.text = description
        rankLabel.text = rank
        
        // 레이아웃 업데이트 및 cornerRadius 재설정
        setNeedsLayout()
        layoutIfNeeded()
        updateCornerRadius()
    }
}




class BannerCollectionViewCell: UICollectionViewCell {

    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .green
        label.numberOfLines = 2
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
        contentView.addSubview(imageView)
        imageView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with image: UIImage, title: String) {
        imageView.image = image
        titleLabel.text = title
    }
}


