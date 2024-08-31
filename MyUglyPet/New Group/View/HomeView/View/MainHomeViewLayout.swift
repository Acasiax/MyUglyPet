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
        
        // 다른 뷰들을 먼저 추가합니다.
        view.addSubview(petButton)
        view.addSubview(uploadButton)
        view.addSubview(collectionView)
        view.addSubview(feedLabel)
        view.addSubview(arrowupLottieAnimationView)
        
        // 마지막에 lottieView를 추가하여 가장 앞에 배치합니다.
        view.addSubview(lottieView)
        
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
        
        // lottieView의 제약 조건 설정
        lottieView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(-30)
                make.centerX.equalToSuperview() // X축(가로축)에서 가운데 정렬
            }
            
        
        feedLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
