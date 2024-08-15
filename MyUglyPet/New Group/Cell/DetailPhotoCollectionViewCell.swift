//
//  DetailPhotoCollectionViewCell.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/15/24.
//

import UIKit
import SnapKit

class DetailPhotoCollectionViewCell: UICollectionViewCell {

    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let overlayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(overlayLabel)
    }
    
    private func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        overlayLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with image: UIImage?, overlayText: String? = nil) {
        imageView.image = image
        if let overlayText = overlayText {
            overlayLabel.text = overlayText
            overlayLabel.isHidden = false
        } else {
            overlayLabel.isHidden = true
        }
    }
}
