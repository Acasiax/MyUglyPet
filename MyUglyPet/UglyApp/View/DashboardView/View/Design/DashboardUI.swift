//
//  DashboardUI.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//

import UIKit

struct DashboardUI {

    static func logoLabel() -> UILabel {
        let label = UILabel()
        label.text = "냥멍난이"
        label.font = CustomFonts.omyuprettyFont(size: 30)
        return label
    }

    static func searchButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        return button
    }

    static func bannerHeaderLabel() -> UILabel {
        let label = UILabel()
        label.text = "배너"
        label.font = CustomFonts.omyuprettyFont(size: 25)
        return label
    }

    static func rankHeaderLabel() -> UILabel {
        let label = UILabel()
        label.text = "순위"
        label.font = CustomFonts.omyuprettyFont(size: 25)
        return label
    }

    static func rankCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 160, height: 200)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RankCollectionViewCell.self, forCellWithReuseIdentifier: RankCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = CustomColors.lightBeige
        return collectionView
    }

    static func hobbyCardHeaderLabel() -> UILabel {
        let label = UILabel()
        label.text = "게시글 작성한 친구들"
        label.font = CustomFonts.omyuprettyFont(size: 25)
        return label
    }

    static func myBuddyCardCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 100)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MyBuddyCardCollectionViewCell.self, forCellWithReuseIdentifier: MyBuddyCardCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = CustomColors.lightBeige
        return collectionView
    }
}

