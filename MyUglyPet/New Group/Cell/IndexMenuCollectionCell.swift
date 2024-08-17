//
//  IndexMenuCollectionCell.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/17/24.
//

import UIKit
import SnapKit

class IndexMenuCollectionCell: UICollectionViewCell {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let carrotLabel = UILabel()
    let actionButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(iconName: String, title: String, carrotCount: Int) {
        iconImageView.image = UIImage(named: "기본냥멍1")
        iconImageView.backgroundColor = .yellow
        titleLabel.text = title
        carrotLabel.text = "🥕 당근 \(carrotCount)개"
        actionButton.setTitle("하러가기", for: .normal)
    }
    
    private func setupCell() {
        contentView.backgroundColor = CustomColors.lightBeige
        contentView.layer.cornerRadius = 10
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(carrotLabel)
        contentView.addSubview(actionButton)
        
        iconImageView.contentMode = .scaleAspectFit
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        carrotLabel.font = UIFont.systemFont(ofSize: 14)
        carrotLabel.textColor = .orange
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        actionButton.backgroundColor = CustomColors.softPink
        actionButton.layer.cornerRadius = 10
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.top.equalToSuperview().offset(10)
        }
        
        carrotLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        actionButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
    }
}
