//
//  DeepPhotoViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/17/24.
//

import UIKit
import SnapKit
import Kingfisher

class CustomPageControl: UIView {
    
    private var stackView = UIStackView()
    private var indicators = [UIImageView]()
    
    var numberOfPages: Int = 0 {
        didSet {
            setupIndicators()
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            updateIndicators()
        }
    }
    
    var currentPageImage: UIImage?
    var pageImage: UIImage?
    var indicatorTintColor: UIColor = .gray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupIndicators() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        indicators.removeAll()
        
        for _ in 0..<numberOfPages {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = indicatorTintColor
            imageView.image = pageImage
            indicators.append(imageView)
            stackView.addArrangedSubview(imageView)
        }
        
        updateIndicators()
    }
    
    private func updateIndicators() {
        for (index, imageView) in indicators.enumerated() {
            imageView.image = index == currentPage ? currentPageImage : pageImage
        }
    }
}




class DeepPhotoViewController: UIViewController {
    
    var photos: [String] = []
    var selectedIndex: Int = 0
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size
        layout.sectionInset = .zero

        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = CustomColors.softBlue
        return collectionView
    }()
    
    private let customPageControl: CustomPageControl = {
        let pageControl = CustomPageControl()
        pageControl.currentPageImage = UIImage(systemName: "pawprint.circle.fill") // 현재 페이지 이미지
    
        pageControl.pageImage = UIImage(systemName: "pawprint.circle") // 기본 페이지 이미지
        return pageControl
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("X", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.softPurple
        view.addSubview(collectionView)
        view.addSubview(customPageControl)
        view.addSubview(closeButton)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        
        customPageControl.numberOfPages = photos.count
        customPageControl.currentPage = selectedIndex
        
        setupConstraints()
        
        
               // 처음 선택된 이미지로 스크롤
               if selectedIndex < photos.count {
                   collectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
               }
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        customPageControl.snp.makeConstraints { make in
            make.bottom.equalTo(collectionView.snp.bottom).offset(-50)
            make.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.width.height.equalTo(44)
        }
    }
    
    @objc private func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension DeepPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("무야호: \(photos.count)")
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        
        // 이미지 URL을 가져옴
        let imageURLString = photos[indexPath.item]
        
        if let imageURL = URL(string: imageURLString) {
            // Kingfisher를 사용하여 이미지를 비동기로 로드
            cell.imageView.kf.setImage(
                with: imageURL,
                placeholder: UIImage(named: "placeholder"),
                options: [.requestModifier(AnyModifier { request in
                    var r = request
                    r.setValue(UserDefaultsManager.shared.token, forHTTPHeaderField: "Authorization")
                    r.setValue(APIKey.key, forHTTPHeaderField: "SesacKey")
                    return r
                })]
            ) { result in
                switch result {
                case .success(let value):
                    print("이미지 로드 성공: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("이미지 로드 실패🔥: \(error.localizedDescription)")
                }
            }
        } else {
            print("URL 변환에 실패했습니다: \(imageURLString)")
        }
        
        return cell
    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        customPageControl.currentPage = pageIndex
    }
}

// MARK: - PhotoCell
class PhotoCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
