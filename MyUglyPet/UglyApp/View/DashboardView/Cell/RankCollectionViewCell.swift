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
      //  view.backgroundColor = CustomColors.softBlue
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
        view.layer.cornerRadius = 10 // profileImageContainerView 둥글게 설정
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "pawprint")
        imageView.layer.cornerRadius = 40 // profileImageView 둥글게 설정
        imageView.clipsToBounds = true // 둥근 모서리를 적용하기 위해 설정
        imageView.layer.borderWidth = 5 // 테두리 두께 설정
        imageView.layer.borderColor = UIColor.white.cgColor // 오렌지색 테두리 설정
        return imageView
    }()

    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.yellow
        label.textColor = .black
        label.textAlignment = .center
        label.font = CustomFonts.omyuprettyFont(size: 20)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.text = "1등"
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "사진제목"
        label.font = CustomFonts.omyuprettyFont(size: 18)
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "견생 5년차"
        label.font = CustomFonts.omyuprettyFont(size: 16)
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 3
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
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(150)
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
            make.leading.equalToSuperview().offset(10)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(12)
        }

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // layoutSubviews에서 둥근 모서리 설정을 재확인할 필요가 없습니다.
    }
    
    func configure(with image: UIImage?, name: String, description: String, rank: String) {
        profileImageView.image = image
        nameLabel.text = name
        descriptionLabel.text = description
        rankLabel.text = rank
        
        setNeedsLayout()
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


