//
//  MainHomeViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Lottie

struct Mission {
    let iconName: String
    let title: String
    let carrotCount: Int
}

struct MissionData {
    static let missions: [Mission] = [
        Mission(iconName: "icon1", title: "망한 사진 월드컵 대회참여하기", carrotCount: 2),
        Mission(iconName: "icon2", title: "후보 구경하기", carrotCount: 3)
    ]
}





import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Lottie

final class MainHomeViewController: UIViewController {

    private let viewModel = MainHomeViewModel()
    private let disposeBag = DisposeBag()
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
        return button
    }()

    private lazy var uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("울 애기 사진 업로드하기", for: .normal)
        button.backgroundColor = .orange
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
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

    private lazy var panGestureRecognizer = UIPanGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = CustomColors.softBlue
        setupLayout()
        bindUI()

        panGestureRecognizer.rx.event
            .bind(with: self) { owner, gesture in
                owner.handlePanGesture(gesture)
            }
            .disposed(by: disposeBag)

        view.addGestureRecognizer(panGestureRecognizer)
    }

    private func setupLayout() {
        view.addSubview(petButton)
        view.addSubview(uploadButton)
        view.addSubview(collectionView)
        view.addSubview(feedLabel)
        view.addSubview(arrowupLottieAnimationView)

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
            make.height.equalTo(arrowupLottieAnimationView.snp.width).multipliedBy(1.0)
        }

        feedLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    private func bindUI() {
        let input = MainHomeViewModel.Input(
            missionSelected: collectionView.rx.itemSelected.map { $0.item },
            petButtonTapped: petButton.rx.tap.asObservable(),
            uploadButtonTapped: uploadButton.rx.tap.asObservable()
        )

        let output = viewModel.transform(input: input, petButton: petButton, uploadButton: uploadButton)

        output.missionToShow
            .subscribe(onNext: { [weak self] viewController in
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)

        output.animatePetButton
            .subscribe()
            .disposed(by: disposeBag)

        output.animateUploadButton
            .subscribe(onNext: { [weak self] in
                let uglyCandidateVC = UglyCandidateViewController()
                self?.navigationController?.pushViewController(uglyCandidateVC, animated: true)
            })
            .disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arrowupLottieAnimationView.isHidden = false
        arrowupLottieAnimationView.play()
    }

    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        if gesture.state == .changed {
            if translation.y < 0 {
                view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        } else if gesture.state == .ended {
            if translation.y < -100 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
                }) { _ in
                    let allPostHomeVC = AllPostHomeViewController()
                    self.navigationController?.pushViewController(allPostHomeVC, animated: true)
                    self.view.transform = .identity
                }
            } else {
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

        cell.actionButton.rx.tap
            .bind(with: self) { owner, _ in
                AnimationZip.animateButtonPress(cell.actionButton)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    owner.viewModel.transform(input: .init(
                        missionSelected: Observable.just(indexPath.item),
                        petButtonTapped: Observable.empty(),
                        uploadButtonTapped: Observable.empty()
                    ), petButton: owner.petButton, uploadButton: owner.uploadButton)
                    .missionToShow
                    .subscribe(onNext: { viewController in
                        owner.navigationController?.pushViewController(viewController, animated: true)
                    }).disposed(by: owner.disposeBag)
                }
            }
            .disposed(by: cell.disposeBag)

        return cell
    }
}
