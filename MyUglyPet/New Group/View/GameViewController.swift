//
//  GameViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/15/24.
//

import UIKit
import SnapKit

class GameViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.00, green: 0.98, blue: 0.88, alpha: 1.00)
        
        setupUI()
    }
    
    func setupUI() {

        let titleLabel = UILabel()
        titleLabel.text = "누가 더 망한 사진인지 골라보세요!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "32강!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .gray
        
        let firstContainerView = UIView()
        firstContainerView.backgroundColor = UIColor(red: 0.95, green: 0.77, blue: 0.98, alpha: 1.00)
        firstContainerView.layer.cornerRadius = 20
        firstContainerView.layer.shadowColor = UIColor.black.cgColor
        firstContainerView.layer.shadowOpacity = 0.1
        firstContainerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        firstContainerView.layer.shadowRadius = 10
        
        let firstTapGesture = UITapGestureRecognizer(target: self, action: #selector(firstContainerTapped))
        firstContainerView.addGestureRecognizer(firstTapGesture)
        
        let firstImageView = UIImageView()
        firstImageView.contentMode = .scaleAspectFill
        firstImageView.image = UIImage(named: "기본냥")
        firstImageView.clipsToBounds = true
        firstImageView.layer.cornerRadius = 50
        
        let firstNameLabel = UILabel()
        firstNameLabel.text = "벼루님"
        firstNameLabel.font = UIFont.systemFont(ofSize: 16)
        firstNameLabel.textAlignment = .center
        
        let firstPriceLabel = UILabel()
        firstPriceLabel.text = "냥생 3개월차"
        firstPriceLabel.font = UIFont.systemFont(ofSize: 14)
        firstPriceLabel.textAlignment = .center
        firstPriceLabel.textColor = .gray

        firstContainerView.addSubview(firstImageView)
        firstContainerView.addSubview(firstNameLabel)
        firstContainerView.addSubview(firstPriceLabel)
        
        let secondContainerView = UIView()
        secondContainerView.backgroundColor = UIColor(red: 0.74, green: 0.88, blue: 1.00, alpha: 1.00)
        secondContainerView.layer.cornerRadius = 20
        secondContainerView.layer.shadowColor = UIColor.black.cgColor
        secondContainerView.layer.shadowOpacity = 0.1
        secondContainerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        secondContainerView.layer.shadowRadius = 10
        
        let secondTapGesture = UITapGestureRecognizer(target: self, action: #selector(secondContainerTapped))
        secondContainerView.addGestureRecognizer(secondTapGesture)
        
        let secondImageView = UIImageView()
        secondImageView.contentMode = .scaleAspectFill
        secondImageView.image = UIImage(named: "기본냥")  // Replace with your image
        secondImageView.clipsToBounds = true
        secondImageView.layer.cornerRadius = 50
        
        let secondNameLabel = UILabel()
        secondNameLabel.text = "꼬질이님"
        secondNameLabel.font = UIFont.systemFont(ofSize: 16)
        secondNameLabel.textAlignment = .center
        
        let secondPriceLabel = UILabel()
        secondPriceLabel.text = "견생 5년차"
        secondPriceLabel.font = UIFont.systemFont(ofSize: 14)
        secondPriceLabel.textAlignment = .center
        secondPriceLabel.textColor = .gray

        secondContainerView.addSubview(secondImageView)
        secondContainerView.addSubview(secondNameLabel)
        secondContainerView.addSubview(secondPriceLabel)
        
        let vsLabel = UILabel()
        vsLabel.text = "VS"
        vsLabel.font = UIFont.boldSystemFont(ofSize: 16)
        vsLabel.textAlignment = .center
        vsLabel.backgroundColor = .systemBlue
        vsLabel.textColor = .white
        vsLabel.layer.cornerRadius = 15
        vsLabel.clipsToBounds = true
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(firstContainerView)
        view.addSubview(secondContainerView)
        view.addSubview(vsLabel)
        
        // Layout using SnapKit
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
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

    @objc func firstContainerTapped() {
        print("첫번째 컨테이너가 선택되었습니다.")
    }

    @objc func secondContainerTapped() {
        print("두번째 컨테이너가 선택되었습니다.")
    }
}
