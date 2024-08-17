//
//  MainHomeViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/15/24.
//

import UIKit
import SnapKit
import Lottie

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
    
    let arrowupLottieAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "arrowup")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        animationView.isHidden = true
        return animationView
    }()
    
    private lazy var petButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "기본냥멍1"), for: .normal)
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
    
    private lazy var feedLabel: UILabel = {
        let label = UILabel()
        
        let fullString = NSMutableAttributedString(string: "\n친구들 게시글 보러가기")
        
        label.attributedText = fullString
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // Pan Gesture Recognizer 추가
    private let panGestureRecognizer = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CustomColors.softBlue
        
        setupLayout()
        
        // Pan Gesture Recognizer 설정
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    deinit {
           print("MainHomeViewController 디이닛")
       }
    
    private func setupLayout() {
        view.addSubview(petButton)
        view.addSubview(uploadButton)
        view.addSubview(collectionView)
        view.addSubview(feedLabel)
        view.addSubview(arrowupLottieAnimationView)  // 애니메이션 추가
        
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
        
        
        arrowupLottieAnimationView.snp.makeConstraints { make in
            make.centerX.equalTo(feedLabel)
            make.bottom.equalTo(feedLabel.snp.top).offset(10)
            make.width.equalTo(30)
            make.height.equalTo(arrowupLottieAnimationView.snp.width).multipliedBy(1.0)  // 비율 유지
        }

        
        feedLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arrowupLottieAnimationView.isHidden = false
        arrowupLottieAnimationView.play()
    }
    
    
    @objc private func petButtonTapped() {
        print("반려동물 이미지 탭")
        AnimationZip.animateButtonPress(petButton)
    }
    
    @objc private func uploadButtonTapped() {
        print("울 애기 사진 업로드하기 버튼 탭")
    }
    
    // Pan Gesture 처리
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        if gesture.state == .changed {
            if translation.y < 0 { // 아래로 드래그 중이면 (y가 음수)
                view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        } else if gesture.state == .ended {
            if translation.y < -100 { // 사용자가 충분히 아래로 스와이프했을 때
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
                }) { _ in
                    let allPostHomeVC = AllPostHomeViewController()
                    let navController = UINavigationController(rootViewController: allPostHomeVC)

                    navController.modalPresentationStyle = .overCurrentContext
                    navController.modalTransitionStyle = .coverVertical

                    self.present(navController, animated: true) {
                        self.view.transform = .identity
                    }

                }
            } else {
                // 드래그 거리가 짧아 원래 위치로 복귀
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                }
            }
        }
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

    
}


