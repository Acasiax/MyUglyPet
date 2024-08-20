//
//  DashboardViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/20/24.
//

import UIKit
import SnapKit

// 더미 데이터 배열
let bannerData: [(image: UIImage, title: String)] = [
    (image: UIImage(named: "기본냥멍1")!, title: "배너 제목 1"),
    (image: UIImage(named: "기본냥멍2")!, title: "배너 제목 2"),
    (image: UIImage(named: "기본냥멍3")!, title: "배너 제목 3")
]



class DashboardViewController: UIViewController {
    
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
        pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
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
        
        bannerCollectionView.dataSource = self
        rankCollectionView.dataSource = self
        hobbyCardCollectionView.dataSource = self
        
        bannerCollectionView.delegate = self
        rankCollectionView.delegate = self
        hobbyCardCollectionView.delegate = self
        
        // 배너의 페이지 수에 맞춰 페이지 컨트롤 설정
        pageControl.numberOfPages = bannerData.count
        
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        view.backgroundColor = CustomColors.lightBeige
        

        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) // 좌측에 10pt 여백 추가
        
        // 로고 및 검색 버튼 추가
        let headerStackView = UIStackView(arrangedSubviews: [logoLabel, searchButton])
        headerStackView.axis = .horizontal
        headerStackView.spacing = 16
        contentStackView.addArrangedSubview(headerStackView)
        
        // 배너 섹션 추가
        contentStackView.addArrangedSubview(bannerHeaderLabel)
        contentStackView.addArrangedSubview(bannerCollectionView)
        contentStackView.addArrangedSubview(pageControl)
        
        // 순위 섹션 추가
        contentStackView.addArrangedSubview(rankHeaderLabel)
        contentStackView.addArrangedSubview(rankCollectionView)
        
        // 취미 카드 섹션 추가
        contentStackView.addArrangedSubview(hobbyCardHeaderLabel)
        contentStackView.addArrangedSubview(hobbyCardCollectionView)
    }
    
    func setupConstraints() {
        // ScrollView 제약 조건
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
    
    // 페이지 컨트롤 값 변경 시 호출되는 메서드
    @objc func pageControlValueChanged(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}




extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case bannerCollectionView:
            return bannerData.count
        case rankCollectionView:
            return 5
        case hobbyCardCollectionView:
            return 10
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case bannerCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as! BannerCollectionViewCell
            let data = bannerData[indexPath.item]
            cell.configure(with: data.image, title: data.title)
            return cell
            
        case rankCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankCollectionViewCell.identifier, for: indexPath) as! RankCollectionViewCell
            cell.configure(with: UIImage(named: "기본냥멍1")!, name: "하하 \(indexPath.row + 1)", description: "호호")
            return cell
            
        case hobbyCardCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HobbyCardCollectionViewCell.identifier, for: indexPath) as! HobbyCardCollectionViewCell
            cell.configure(with: UIImage(named: "기본냥멍1")!, title: "유저 \(indexPath.row + 1)", description: "이것은 취미 카드 설명입니다.")
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            let page = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            pageControl.currentPage = page
        }
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
    
    func setupUI() {
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











