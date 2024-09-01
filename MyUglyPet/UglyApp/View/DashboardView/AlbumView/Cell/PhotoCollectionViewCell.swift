//
//  PhotoCollectionViewCell.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "기본냥멍1")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    // MARK: - 설정
    
    func configure(with photo: Photo, collectionView: UICollectionView) {
        nameLabel.text = photo.user.name
        
        // 여러 이미지 중 첫 번째 이미지를 사용
        if let imageUrl = photo.imageUrls.first {
            let fullImageURLString = APIKey.baseURL + "v1/" + imageUrl
            if let url = URL(string: fullImageURLString) {
                let headers = Router.fetchPosts(query: FetchReadingPostQuery(next: nil, limit: "10", product_id: "")).headersForImageRequest
                
                let modifier = AnyModifier { request in
                    var r = request
                    r.allHTTPHeaderFields = headers
                    return r
                }
                
                photoImageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "placeholder"),
                    options: [
                        .requestModifier(modifier),
                        .transition(.fade(0.3))
                    ]
                ) { result in
                    switch result {
                    case .success(let value):
                        let imageSize = value.image.size
                        self.adjustLayoutForImageSize(imageSize, collectionView: collectionView)
                    case .failure(let error):
                        print("이미지 로드 실패: \(error.localizedDescription)")
                        self.photoImageView.image = UIImage(named: "기본냥멍2")
                    }
                }
            } else {
                print("유효하지 않은 URL: \(fullImageURLString)")
                photoImageView.image = UIImage(named: "기본냥멍2")
            }
        } else {
            photoImageView.image = UIImage(named: "기본냥멍2")
        }
    }

    private func adjustLayoutForImageSize(_ size: CGSize, collectionView: UICollectionView) {
        let aspectRatio = size.width / size.height

        // 이미지의 가로 세로 비율에 따라 제약 조건을 다시 설정
        photoImageView.snp.remakeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(photoImageView.snp.width).multipliedBy(1/aspectRatio)
        }

        // 레이아웃 변경 사항을 반영하기 위해 컬렉션 뷰의 배치를 업데이트 하는거
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = UIImage(named: "기본냥멍2")
        nameLabel.text = nil
    }
}
