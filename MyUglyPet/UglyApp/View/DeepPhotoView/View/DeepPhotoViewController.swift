//
//  DeepPhotoViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/17/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

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
        pageControl.currentPageImage = UIImage(systemName: "pawprint.circle.fill")
        pageControl.pageImage = UIImage(systemName: "pawprint.circle")
        return pageControl
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("X", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel = DeepPhotoViewModel()
    private let selectedIndexSubject = BehaviorSubject<Int>(value: 0)
    
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
        
        bindViewModel()
        
        // 처음 선택된 이미지로 스크롤
        if selectedIndex < photos.count {
            collectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
            selectedIndexSubject.onNext(selectedIndex)
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
    
    private func bindViewModel() {
        let input = DeepPhotoViewModel.Input(
            closeButtonTap: closeButton.rx.tap.asObservable(),
            selectedIndex: selectedIndexSubject.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.currentPage
            .drive(customPageControl.rx.currentPage)
            .disposed(by: disposeBag)
        
        output.close
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - 상세보기 컬렉션뷰
extension DeepPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("무야호: \(photos.count)")
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        
        let imageURLString = photos[indexPath.item]
        
        if let imageURL = URL(string: imageURLString) {
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
        selectedIndexSubject.onNext(pageIndex)
    }
}

// MARK: - 상세 사진 셀
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
