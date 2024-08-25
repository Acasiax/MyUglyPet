//
//  MainHomeViewLayout.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import Foundation
import SnapKit

extension MainHomeViewController {
    
    func setupLayout() {
        view.addGestureRecognizer(panGestureRecognizer)
        view.addSubview(petButton)
        view.addSubview(uploadButton)
        view.addSubview(collectionView)
        view.addSubview(feedLabel)
        view.addSubview(arrowupLottieAnimationView)
        
        setupConstraints()
    }
    
    
    func setupConstraints() {
        petButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-200)
            make.width.height.equalTo(150)
        }
        
        uploadButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(petButton.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(uploadButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        arrowupLottieAnimationView.snp.makeConstraints { make in
            make.centerX.equalTo(feedLabel)
            make.bottom.equalTo(feedLabel.snp.top).offset(10)
            make.width.equalTo(30)
            make.height.equalTo(arrowupLottieAnimationView.snp.width).multipliedBy(1.0)
        }
        
        feedLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    
}
