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

final class MainHomeViewController: UIViewController {
    
    let viewModel = MainHomeViewModel()
    let disposeBag = DisposeBag()
    let missions: [Mission] = MissionData.missions
    

    lazy var arrowupLottieAnimationView: LottieAnimationView = MainHomeUI.UiArrowupLottieAnimationView()
    lazy var petButton: UIButton = MainHomeUI.UiPetButton()
    lazy var uploadButton: UIButton = MainHomeUI.UiUploadButton()
    lazy var collectionView: UICollectionView = MainHomeUI.UiCollectionView(delegate: self)
    lazy var feedLabel: UILabel = MainHomeUI.UiFeedLabel()
    lazy var panGestureRecognizer = UIPanGestureRecognizer()
    
    lazy var lottieView: LottieAnimationView = {
            let view = LottieAnimationView(name: "Congratulation")
            view.contentMode = .scaleAspectFit
            view.loopMode = .playOnce
            view.isHidden = true
            return view
        }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.softBlue
        setupUI()
        bindUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startLottieAnimation()
    }

    func setupUI() {
        setupLayout()
        
        panGestureRecognizer.rx.event
            .bind(with: self) { owner, gesture in
                owner.handlePanGesture(gesture)
            }
            .disposed(by: disposeBag)
        
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func startLottieAnimation() {
        arrowupLottieAnimationView.isHidden = false
        arrowupLottieAnimationView.play()
    }
    
    func animateLottieAnimation() {
        DispatchQueue.main.async {
            self.lottieView.isHidden = false
            
            // 애니메이션 재생
            self.lottieView.play { [weak self] _ in
                // 애니메이션이 완료된 후 lottieView를 숨기기
                self?.lottieView.isHidden = true
            }
        }
    }

    
}

// MARK: - rx로 바인딩한거
extension MainHomeViewController {
    func bindUI() {
        let input = MainHomeViewModel.Input(
            missionSelected: collectionView.rx.itemSelected.map { $0.item },
            petButtonTapped: petButton.rx.tap.asObservable(),
            uploadButtonTapped: uploadButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input, petButton: petButton, uploadButton: uploadButton)
        
        //화면 이동
        output.missionToShow
            .subscribe(onNext: { [weak self] viewController in
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)

        output.animatePetButton
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.animateLottieAnimation()
            })
            .disposed(by: disposeBag)


        
        output.animateUploadButton
            .subscribe(onNext: { [weak self] in
              
                let uglyCandidateVC = UglyCandidateViewController()
                self?.navigationController?.pushViewController(uglyCandidateVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - 컬렉션뷰 설정
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
                owner.handleActionButtonTap(for: indexPath, in: cell)
            }
            .disposed(by: cell.disposeBag)
        
        return cell
    }
    
    // MARK: - 액션 핸들러
    func handleActionButtonTap(for indexPath: IndexPath, in cell: IndexMenuCollectionCell) {
        AnimationZip.animateButtonPress(cell.actionButton)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.viewModel.transform(input: .init(
                missionSelected: Observable.just(indexPath.item),
                petButtonTapped: Observable.empty(),
                uploadButtonTapped: Observable.empty()
            ), petButton: self.petButton, uploadButton: self.uploadButton)
            .missionToShow
            .subscribe(onNext: { viewController in
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: self.disposeBag)
        }
    }
}

// MARK: - 밑으로 내리면 화면 전환
extension MainHomeViewController {
    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
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


