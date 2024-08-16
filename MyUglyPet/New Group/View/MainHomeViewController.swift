//
//  MainHomeViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/15/24.
//
//베이지 UIColor(red: 1.00, green: 0.98, blue: 0.88, alpha: 1.00)
//블루  UIColor(red: 0.74, green: 0.88, blue: 1.00, alpha: 1.00)


import UIKit
import SnapKit

struct Mission {
    let iconName: String
    let title: String
    let carrotCount: Int
}

struct MissionData {
    static let missions: [Mission] = [
        Mission(iconName: "icon1", title: "망한 사진 월드컵 대회참여하기", carrotCount: 2),
        Mission(iconName: "icon2", title: "우리 애기 사진도 올리기", carrotCount: 3)
    ]
}


class MainHomeViewController: UIViewController {

    private let missions: [Mission] = MissionData.missions
    

    private lazy var petButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "기본냥멍1"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = 75
        button.layer.borderColor = UIColor.orange.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(dogButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("울 애기 사진 업로드하기", for: .normal)
        button.backgroundColor = .orange
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width - 40, height: 60)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(MissionCell.self, forCellWithReuseIdentifier: MissionCell.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CustomColors.softBlue
        
        setupLayout() 
    }

    private func setupLayout() {
        view.addSubview(petButton)
        view.addSubview(uploadButton)
        view.addSubview(collectionView)
        
        setupConstraints()
    }

    private func setupConstraints() {
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
    }

    @objc private func dogButtonTapped() {
        print("반려동물 이미지 탭")
    }

  

   
}


extension MainHomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionCell.identifier, for: indexPath) as! MissionCell
        let mission = missions[indexPath.item]
        cell.configure(iconName: mission.iconName, title: mission.title, carrotCount: mission.carrotCount)
        cell.actionButton.addTarget(self, action: #selector(missionButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("인덱스 \(indexPath.item) 눌렀지요")
    }
    
    @objc private func missionButtonTapped() {
        print("매뉴 버튼 탭")
    }
    @objc private func uploadButtonTapped() {
        print("업로드 버튼 탭")
    }
    
    
}


class MissionCell: UICollectionViewCell {
    
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
