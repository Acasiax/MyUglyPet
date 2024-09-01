//
//  GameViewLayout.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import Foundation

extension GameViewController {
    
    func addsub() {
        view.addSubview(basicLottieAnimationView)
        view.addSubview(pinkLottieAnimationView)
        view.addSubview(congratulationAnimationView)
        
        view.addSubview(worldCupLabel)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(firstContainerView)
        view.addSubview(secondContainerView)
        view.addSubview(vsLabel)
        view.addSubview(winnerTitleLabel)
        view.addSubview(submitWinnerButton)
        
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
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(190)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        winnerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        firstContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(160)
            make.height.equalTo(200)
        }
        
        secondContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
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
        
        basicLottieAnimationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pinkLottieAnimationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        congratulationAnimationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.centerX.equalToSuperview() // X축(가로축)에서 가운데 정렬
        }
                
        winnerContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(250)
            make.centerY.equalToSuperview().offset(-30)
        }
        
        winnerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        winnerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(winnerImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        winnerAgeLabel.snp.makeConstraints { make in
            make.top.equalTo(winnerNameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        
        submitWinnerButton.snp.makeConstraints { make in
            make.top.equalTo(winnerContainerView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        
    }
    
}
