//
//  IntroUglyCandidateViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/23/24.
//

import UIKit
import SnapKit
import Alamofire
import RxSwift
import RxCocoa


class IntroUglyCandidateViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 후보에 들어간\n참가자 개수는?"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let postCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 15개"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    let explanationLabel: UILabel = {
        let label = UILabel()
        label.text = "게임이 시작되려면 최소 8개의 사진이 필요합니다."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 2
        return label
    }()
    
    let letgoRegisterCandidateButton: UIButton = {
        let button = UIButton()
        button.setTitle("게임 시작", for: .normal)
        button.backgroundColor = CustomColors.softPink
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false // 초기에는 비활성화
        button.alpha = 0.5 // 비활성화 시 시각적으로 나타내기 위해 반투명 설정
        return button
    }()
    
    // 서버에서 받아온 포스팅을 저장할 배열
    var serverPosts: [PostsModel] = []
    
    // DisposeBag 생성
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.lightBeige
        
        addSubviews()
        setupLayout()
        bindUI()
        fetchPosts()
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(postCountLabel)
        view.addSubview(explanationLabel)
        view.addSubview(letgoRegisterCandidateButton)
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        postCountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
        }

        explanationLabel.snp.makeConstraints { make in
            make.top.equalTo(postCountLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        letgoRegisterCandidateButton.snp.makeConstraints { make in
            make.top.equalTo(explanationLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(60)
        }
    }
    
    private func bindUI() {
        letgoRegisterCandidateButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.didTapLetgoRegisterCandidateButton()
            }
            .disposed(by: disposeBag)
    }
    
    private func didTapLetgoRegisterCandidateButton() {
        print("게임 시작 버튼이 눌렸습니다")
    }
    
    private func fetchPosts() {
        // 쿼리 파라미터 생성
        let query = FetchReadingPostQuery(next: nil, limit: "60", product_id: "못난이후보등록")

        PostNetworkManager.shared.fetchPosts(query: query) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let posts):
                self.serverPosts = posts
                
                // 포스팅 개수를 레이블에 표시하고 버튼 상태 업데이트
                self.updatePostCountLabel(postCount: posts.count)
                
                print("포스팅을 가져오는데 성공했어요🥰")
            case .failure(let error):
                print("포스팅을 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }
    
    private func updatePostCountLabel(postCount: Int) {
        postCountLabel.text = "\(postCount) / 15개"
        
        // 포스팅 개수가 15개 이상이면 버튼 숨기기
        if postCount >= 8 && postCount <= 15 {
            letgoRegisterCandidateButton.isHidden = false
            letgoRegisterCandidateButton.isEnabled = true
            letgoRegisterCandidateButton.alpha = 1.0 // 버튼 활성화 시 투명도 복구
        } else if postCount > 15 {
            letgoRegisterCandidateButton.isHidden = true
        } else {
            letgoRegisterCandidateButton.isEnabled = false
            letgoRegisterCandidateButton.alpha = 0.5 // 비활성화 시 투명도 설정
        }
    }
}
