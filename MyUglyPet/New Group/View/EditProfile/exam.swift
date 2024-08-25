//
//  exam.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RoutineViewController: UIViewController {
    
    // MARK: - Variables
    
    private lazy var perfectMorningButton: UIButton = {
        let button = createButton(withTitle: "게시글 관리", backgroundColor: CustomColors.warmYellow)
        return button
    }()
    
    private lazy var productiveAfternoonButton: UIButton = {
        let button = createButton(withTitle: "프로필 수정", backgroundColor: CustomColors.mintGreen)
        return button
    }()
    
    private lazy var relaxedEveningButton: UIButton = {
        let button = createButton(withTitle: "팔로잉 목록", backgroundColor: CustomColors.softCoral)
        return button
    }()
    
    private lazy var increaseWealthButton: UIButton = {
        let button = createButton(withTitle: "팔로워 목록", backgroundColor: CustomColors.skyBlue)
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.softIvory
        setupViews()
        setupAutoLayout()
        bindButtons()
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        view.addSubview(perfectMorningButton)
        view.addSubview(productiveAfternoonButton)
        view.addSubview(relaxedEveningButton)
        view.addSubview(increaseWealthButton)
    }
    
    // MARK: - Setup Auto Layout
    
    private func setupAutoLayout() {
        let padding: CGFloat = 5
        
        perfectMorningButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(padding)
            make.leading.equalToSuperview().offset(padding)
            make.width.height.equalTo(130)
        }
        
        productiveAfternoonButton.snp.makeConstraints { make in
            make.top.equalTo(perfectMorningButton.snp.top)
            make.leading.equalTo(perfectMorningButton.snp.trailing).offset(padding)
            make.width.height.equalTo(130)
        }
        
        relaxedEveningButton.snp.makeConstraints { make in
            make.top.equalTo(perfectMorningButton.snp.bottom).offset(padding)
            make.leading.equalToSuperview().offset(padding)
            make.width.height.equalTo(130)
        }
        
        increaseWealthButton.snp.makeConstraints { make in
            make.top.equalTo(relaxedEveningButton.snp.top)
            make.leading.equalTo(relaxedEveningButton.snp.trailing).offset(padding)
            make.width.height.equalTo(130)
        }
    }
    
    // MARK: - Bind Buttons
    
    private func bindButtons() {
        perfectMorningButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.handlePerfectMorningButtonTap()
            }
            .disposed(by: disposeBag)
        
        productiveAfternoonButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.handleProductiveAfternoonButtonTap()
            }
            .disposed(by: disposeBag)
        
        relaxedEveningButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.handleRelaxedEveningButtonTap()
            }
            .disposed(by: disposeBag)
        
        increaseWealthButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.handleIncreaseWealthButtonTap()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Button Handlers
    
    private func handlePerfectMorningButtonTap() {
        print("게시글 관리 버튼이 눌렸습니다.")
        // 여기에 버튼 클릭 시 실행할 코드를 추가하세요
    }
    
    private func handleProductiveAfternoonButtonTap() {
        print("팔로워 목록 버튼이 눌렸습니다.")
        // 여기에 버튼 클릭 시 실행할 코드를 추가하세요
    }
    
    private func handleRelaxedEveningButtonTap() {
        print("팔로잉 목록 버튼이 눌렸습니다.")
        // 여기에 버튼 클릭 시 실행할 코드를 추가하세요
    }
    
    private func handleIncreaseWealthButtonTap() {
        print("프로필수정 버튼이 눌렸습니다.")
        // 여기에 버튼 클릭 시 실행할 코드를 추가하세요
    }
    
    // MARK: - Helper Functions
    
    private func createButton(withTitle title: String, backgroundColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        return button
    }
}
