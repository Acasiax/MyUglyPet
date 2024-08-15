//
//  GameViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/15/24.
//

import UIKit
import SnapKit

class GameViewController: UIViewController {

    let titleLabel: UILabel = {
           let label = UILabel()
           label.text = "누가 더 망한 사진인지 골라보세요!"
           label.font = UIFont.boldSystemFont(ofSize: 24)
           label.textAlignment = .center
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
           view.backgroundColor = UIColor(red: 0.95, green: 0.77, blue: 0.98, alpha: 1.00)
           view.layer.cornerRadius = 20
           view.layer.shadowColor = UIColor.black.cgColor
           view.layer.shadowOpacity = 0.1
           view.layer.shadowOffset = CGSize(width: 0, height: 5)
           view.layer.shadowRadius = 10
           
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(firstContainerTapped))
           view.addGestureRecognizer(tapGesture)
           
           return view
       }()
       
       let firstImageView: UIImageView = {
           let imageView = UIImageView()
           imageView.contentMode = .scaleAspectFill
           imageView.image = UIImage(named: "기본냥")
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
           view.backgroundColor = UIColor(red: 0.74, green: 0.88, blue: 1.00, alpha: 1.00)
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
           imageView.image = UIImage(named: "기본냥")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 처음 위치를 화면 아래로 설정
        firstContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        secondContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)

        // 애니메이션 블록
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.firstContainerView.transform = .identity  // 원래 위치로 복원
            self.secondContainerView.transform = .identity 
        }, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.00, green: 0.98, blue: 0.88, alpha: 1.00)
        addsub()
        setupUI()
        let secondTapGesture = UITapGestureRecognizer(target: self, action: #selector(secondContainerTapped))
        secondContainerView.addGestureRecognizer(secondTapGesture)
    }
    
    func addsub() {
        
        firstContainerView.addSubview(firstImageView)
        firstContainerView.addSubview(firstNameLabel)
        firstContainerView.addSubview(firstPriceLabel)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(firstContainerView)
        view.addSubview(secondContainerView)
        view.addSubview(vsLabel)
        secondContainerView.addSubview(secondImageView)
        secondContainerView.addSubview(secondNameLabel)
        secondContainerView.addSubview(secondPriceLabel)
    }
    
    func setupUI() {

       
        
        
        
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
