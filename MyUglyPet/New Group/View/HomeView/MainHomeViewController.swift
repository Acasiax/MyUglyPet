//
//  MainHomeViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/15/24.
//

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
        button.addTarget(self, action: #selector(petButtonTapped), for: .touchUpInside)
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
        collectionView.register(IndexMenuCollectionCell.self, forCellWithReuseIdentifier: IndexMenuCollectionCell.identifier)
        
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

    @objc private func petButtonTapped() {
        print("반려동물 이미지 탭")
        AnimationZip.animateButtonPress(petButton)
    }

  

   
}


extension MainHomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndexMenuCollectionCell.identifier, for: indexPath) as! IndexMenuCollectionCell
        let mission = missions[indexPath.item]
        cell.configure(iconName: mission.iconName, title: mission.title, carrotCount: mission.carrotCount)
        cell.actionButton.addTarget(self, action: #selector(missionButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("인덱스 \(indexPath.item) 눌렀지요")
        // guard let cell = sender.superview?.superview as? MissionCell else { return }
       
    }
    
    @objc private func missionButtonTapped(_ sender: UIButton) {
        // 어떤 셀의 버튼이 눌렸는지 확인하기 위해 sender를 이용
        guard let cell = sender.superview?.superview as? IndexMenuCollectionCell else { return }
        
        // 해당 셀의 인덱스를 찾기 위해 collectionView에서 인덱스 가져오기
        guard let indexPath = collectionView.indexPath(for: cell) else { return }

        print("하러가기 버튼 탭, 인덱스: \(indexPath.item)")

        // 버튼 애니메이션 실행
        AnimationZip.animateButtonPress(sender)
        
        // 애니메이션이 끝난 후에 화면 전환을 하기 위해 비동기 작업 추가
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 0.3초 후에 실행
            // 인덱스가 0일 경우 GameViewController로 이동
            if indexPath.item == 0 {
                let gameViewController = GameViewController()
                self.navigationController?.pushViewController(gameViewController, animated: true)
            }
        }
    }



    @objc private func uploadButtonTapped() {
        print("업로드 버튼 탭")
        AnimationZip.animateButtonPress(uploadButton)
    }
    
    
}


