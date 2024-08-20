//
//  DashboardViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/20/24.
//
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// 더미 데이터 배열
let bannerData: [(image: UIImage, title: String)] = [
    (image: UIImage(named: "기본냥멍1")!, title: "배너 제목 1"),
    (image: UIImage(named: "기본냥멍2")!, title: "배너 제목 2"),
    (image: UIImage(named: "기본냥멍3")!, title: "배너 제목 3")
]

class DashboardViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    let scrollView = UIScrollView()
    let contentStackView = UIStackView()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "냥멍난이"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    // 배너 섹션 헤더
    let bannerHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "배너"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    // 배너 컬렉션 뷰
    let bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 150)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // 페이지 컨트롤
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }()
    
    // 순위 섹션 헤더
    let rankHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "순위"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    // 순위 컬렉션 뷰
    let rankCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 160)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RankCollectionViewCell.self, forCellWithReuseIdentifier: RankCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = CustomColors.softPink
        return collectionView
    }()
    
    // 취미 카드 섹션 헤더
    let hobbyCardHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "취미 카드"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    // 취미 카드 컬렉션 뷰
    let hobbyCardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 100)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HobbyCardCollectionViewCell.self, forCellWithReuseIdentifier: HobbyCardCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = CustomColors.softPurple
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupConstraints()
        bindData()
    }
    
    func setupSubviews() {
        view.backgroundColor = CustomColors.lightBeige
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) // 좌측에 10pt 여백 추가
        
        let headerStackView = UIStackView(arrangedSubviews: [logoLabel, searchButton])
        headerStackView.axis = .horizontal
        headerStackView.spacing = 16
        contentStackView.addArrangedSubview(headerStackView)
        
        contentStackView.addArrangedSubview(bannerHeaderLabel)
        contentStackView.addArrangedSubview(bannerCollectionView)
        contentStackView.addArrangedSubview(pageControl)
        
        contentStackView.addArrangedSubview(rankHeaderLabel)
        contentStackView.addArrangedSubview(rankCollectionView)
        
        contentStackView.addArrangedSubview(hobbyCardHeaderLabel)
        contentStackView.addArrangedSubview(hobbyCardCollectionView)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        bannerCollectionView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
        
        rankCollectionView.snp.makeConstraints { make in
            make.height.equalTo(230)
        }
        
        hobbyCardCollectionView.snp.makeConstraints { make in
            make.height.equalTo(400) // 필요 시 조정 가능
        }
    }
    
    func bindData() {
        // 배너 데이터 바인딩
        Observable.just(bannerData)
            .bind(to: bannerCollectionView.rx.items(cellIdentifier: BannerCollectionViewCell.identifier, cellType: BannerCollectionViewCell.self)) { index, model, cell in
                cell.configure(with: model.image, title: model.title)
            }
            .disposed(by: disposeBag)
        
        // 페이지 컨트롤과 컬렉션 뷰의 스크롤 바인딩
        bannerCollectionView.rx.contentOffset
            .map { Int($0.x / UIScreen.main.bounds.width) }
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
        
        // 페이지 컨트롤의 값 변화에 따른 컬렉션 뷰 스크롤
        pageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
                self.bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 순위 섹션 데이터 바인딩
        Observable.just(Array(1...5))
            .bind(to: rankCollectionView.rx.items(cellIdentifier: RankCollectionViewCell.identifier, cellType: RankCollectionViewCell.self)) { index, model, cell in
                let image = UIImage(named: "기본냥멍1")!
                cell.bindData(image: Observable.just(image), name: Observable.just("하하 \(model)"), description: Observable.just("호호"))
            }
            .disposed(by: disposeBag)
        
        // 취미 카드 섹션 데이터 바인딩
        Observable.just(Array(1...10))
            .bind(to: hobbyCardCollectionView.rx.items(cellIdentifier: HobbyCardCollectionViewCell.identifier, cellType: HobbyCardCollectionViewCell.self)) { index, model, cell in
                let image = UIImage(named: "기본냥멍1")!
                cell.bindData(image: Observable.just(image), title: Observable.just("유저 \(model)"), description: Observable.just("이것은 취미 카드 설명입니다."))
            }
            .disposed(by: disposeBag)
    }
}

class BannerCollectionViewCell: UICollectionViewCell {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .green
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
        imageView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with image: UIImage, title: String) {
        imageView.image = image
        titleLabel.text = title
    }
}

