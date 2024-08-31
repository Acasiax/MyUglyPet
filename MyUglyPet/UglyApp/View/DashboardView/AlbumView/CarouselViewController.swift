//
//  CarouselViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/28/24.
//

import UIKit
import SnapKit

class CardCarouselViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var collectionView: UICollectionView!
    private var images: [UIImage] = [] // 카드에 표시할 이미지 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        // 이미지 데이터를 추가합니다. 여기서는 샘플 이미지를 사용합니다.
        images = [
            UIImage(named: "book mockup")!,
            UIImage(named: "book mockup")!,
            UIImage(named: "book mockup")!,
            UIImage(named: "book mockup")!,
            UIImage(named: "book mockup")!,
            UIImage(named: "book mockup")!
           
        ]
        
        // 캐러셀 레이아웃을 설정합니다.
        let layout = CarouselLayout()
       // layout.itemSize = CGSize(width: view.frame.width * 0.7, height: view.frame.height * 0.5)
        
        layout.itemSize = CGSize(width: view.frame.width * 0.35, height: view.frame.height * 0.25)

        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
        
        view.addSubview(collectionView)
        
        // SnapKit을 사용하여 컬렉션 뷰의 오토레이아웃 설정
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview() 
        }

    }
    
    // UICollectionViewDataSource 메서드 구현
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as! CardCell
        cell.configure(with: images[indexPath.item])
        return cell
    }
    
    
    
    // 셀을 선택했을 때 호출되는 메서드
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let selectedCell = collectionView.cellForItem(at: indexPath) as? CardCell else { return }
            
            // 애니메이션 적용
            AnimationZip.animatePress(on: selectedCell) { [weak self] in
                // 애니메이션이 끝난 후 화면 전환
                let detailVC = AlbumPhotoListViewController() // 새 CardCarouselViewController 인스턴스를 생성
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    
    
    // 스크롤 뷰가 멈출 때 스냅 효과를 주는 메서드
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

import UIKit
import SnapKit

class CardCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        // SnapKit을 사용하여 imageView의 오토레이아웃 설정
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
}



import UIKit

class CarouselLayout: UICollectionViewFlowLayout {
    
    public var sideItemScale: CGFloat = 0.5
    public var sideItemAlpha: CGFloat = 0.5
    public var spacing: CGFloat = 10

    public var isPagingEnabled: Bool = false
    
    private var isSetup: Bool = false
    
    override public func prepare() {
        super.prepare()
        if isSetup == false {
            setupLayout()
            isSetup = true
        }
    }
    
    private func setupLayout() {
        guard let collectionView = self.collectionView else {return}
                
        let collectionViewSize = collectionView.bounds.size
        
        let xInset = (collectionViewSize.width - self.itemSize.width) / 2
        let yInset = (collectionViewSize.height - self.itemSize.height) / 2
        
        self.sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        let itemWidth = self.itemSize.width
        
        let scaledItemOffset =  (itemWidth - itemWidth*self.sideItemScale) / 2
        self.minimumLineSpacing = spacing - scaledItemOffset

        self.scrollDirection = .horizontal
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        
        return attributes.map({ self.transformLayoutAttributes(attributes: $0) })
    }
    
    private func transformLayoutAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        guard let collectionView = self.collectionView else {return attributes}
        
        let collectionCenter = collectionView.frame.size.width / 2
        let contentOffset = collectionView.contentOffset.x
        let center = attributes.center.x - contentOffset
        
        let maxDistance = self.itemSize.width + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - center), maxDistance)

        let ratio = (maxDistance - distance)/maxDistance

        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        
        attributes.alpha = alpha
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let dist = attributes.frame.midX - visibleRect.midX
        var transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        transform = CATransform3DTranslate(transform, 0, 0, -abs(dist/1000))
        attributes.transform3D = transform
        
        return attributes
    }
}
