//
//  CategoryCollectionViewCell.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/20/24.
//


import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RankCollectionViewCell: UICollectionViewCell {
    private var disposeBag = DisposeBag()  // DisposeBag을 명시적으로 선언
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.softBlue
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }
    
    func bindData(image: Observable<UIImage?>, name: Observable<String>, description: Observable<String>) {
        // DisposeBag 초기화: 셀 재사용 시 이전 바인딩 해제
        disposeBag = DisposeBag()
        
        image
            .bind(to: profileImageView.rx.image)
            .disposed(by: disposeBag)
        
        name
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        description
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

class HobbyCardCollectionViewCell: UICollectionViewCell {
    private var disposeBag = DisposeBag()  // DisposeBag을 명시적으로 선언

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(imageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    func bindData(image: Observable<UIImage?>, title: Observable<String>, description: Observable<String>) {
        // DisposeBag 초기화: 셀 재사용 시 이전 바인딩 해제
        disposeBag = DisposeBag()
        
        image
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        description
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}


