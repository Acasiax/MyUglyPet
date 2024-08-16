//
//  BaseGameView.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/16/24.
//

import UIKit
import SnapKit

class BaseGameView: UIViewController {
    
    let worldCupLabel: UILabel = {
        let label = UILabel()
        label.text = "망한 사진 월드컵"
        label.backgroundColor = CustomColors.softPink
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.layer.cornerRadius = 13
        label.clipsToBounds = true
        
        return label
    }()

    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "둘 중에 \n 더 망한 사진을 골라보세요!"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "32강!"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    let firstContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.softPurple
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        
        return view
    }()
    
    let firstImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "star")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "벼루님"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let firstPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "냥생 3개월차"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    let secondContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.softBlue
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        return view
    }()
    
    let secondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "figure.stand")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    let secondNameLabel: UILabel = {
        let label = UILabel()
        label.text = "꼬질이님"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let secondPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "견생 5년차"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    let vsLabel: UILabel = {
        let label = UILabel()
        label.text = "VS"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.backgroundColor = .systemBlue
        label.textColor = .white
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
    }()
    
    let winnerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        view.isHidden = true // 처음에는 숨김
        return view
    }()

    let winnerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "star")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()

    let winnerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "우승자"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    let winnerAgeLabel: UILabel = {
        let label = UILabel()
        label.text = "나이"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()

    
    
    func addsub() {
        
        view.addSubview(worldCupLabel)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(firstContainerView)
        view.addSubview(secondContainerView)
        view.addSubview(vsLabel)
        firstContainerView.addSubview(firstImageView)
        firstContainerView.addSubview(firstNameLabel)
        firstContainerView.addSubview(firstPriceLabel)
        
        
        secondContainerView.addSubview(secondImageView)
        secondContainerView.addSubview(secondNameLabel)
        secondContainerView.addSubview(secondPriceLabel)
        
        view.addSubview(winnerContainerView)
            winnerContainerView.addSubview(winnerImageView)
            winnerContainerView.addSubview(winnerNameLabel)
            winnerContainerView.addSubview(winnerAgeLabel)
    }
    
    func setupUI() {
        
        worldCupLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40) // 높이를 설정
            make.width.equalTo(130) // 텍스트보다 넓게 설정
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(worldCupLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        firstContainerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(160)
            make.height.equalTo(200)
        }
        
        secondContainerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(160)
            make.height.equalTo(200)
        }
        
        firstImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        firstNameLabel.snp.makeConstraints { make in
            make.top.equalTo(firstImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        firstPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        secondImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        secondNameLabel.snp.makeConstraints { make in
            make.top.equalTo(secondImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        secondPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(secondNameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        vsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(firstContainerView)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        
        
        
        
        
    }
}
