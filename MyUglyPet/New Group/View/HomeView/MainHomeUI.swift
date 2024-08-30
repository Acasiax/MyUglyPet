//
//  MainHomeUIFactory.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit
import SnapKit
import Lottie

struct MainHomeUI {

   
    static func UiArrowupLottieAnimationView() -> LottieAnimationView {
        let animationView = LottieAnimationView(name: "arrowup")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        animationView.isHidden = true
        return animationView
    }

    static func UiPetButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "기본냥멍1"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = 75
        button.layer.borderColor = CustomColors.softPink.cgColor
        button.layer.borderWidth = 2
        return button
    }

    static func UiUploadButton() -> UIButton {
        let button = UIButton()
        button.setTitle("울 애기 사진 업로드하기", for: .normal)
        button.backgroundColor = CustomColors.softPink
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        return button
    }

    static func UiCollectionView(delegate: UICollectionViewDelegate & UICollectionViewDataSource) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 60)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = delegate
        collectionView.delegate = delegate
        collectionView.backgroundColor = .clear
        collectionView.register(IndexMenuCollectionCell.self, forCellWithReuseIdentifier: IndexMenuCollectionCell.identifier)

        return collectionView
    }

    static func UiFeedLabel() -> UILabel {
        let label = UILabel()
        let fullString = NSMutableAttributedString(string: "\n친구들 게시글 보러가기")
        label.attributedText = fullString
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
}

