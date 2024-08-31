//
//  TestPhoto.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/28/24.
//


//결제 서비스 면접 볼때 면접관들이 자주 물어본다고 함.


import UIKit
import SnapKit
import Kingfisher

final class AlbumPhotoListViewController: UIViewController {
    
    private var serverPosts: [PostsModel] = []
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    
    private enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupViews()
        setupDataSource()
        fetchPosts()
    }
    
    
    private func setupViews() {
        view.addSubview(photoCollectionView)
        
        photoCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalWidth(0.75)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
    }
    
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: photoCollectionView) { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: photo, collectionView: collectionView)
            return cell
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([.main])
        
        let photos = serverPosts.compactMap { post -> Photo? in
            guard let imageUrls = post.files else {
                return nil
            }
            return Photo(
                id: post.postId,
                user: User(name: post.creator.nick),
                imageUrls: imageUrls // 이미지 URL 리스트를 사용
            )
        }
        
        snapshot.appendItems(photos)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - 서버 로직
extension AlbumPhotoListViewController {
    // 게시글 모든 피드 가져오기
    private func fetchPosts() {
        let query = FetchReadingPostQuery(next: nil, limit: "30", product_id: "allFeed")
        
        PostNetworkManager.shared.fetchPosts(query: query) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.serverPosts = posts
                self?.applySnapshot()  // 데이터를 불러온 후 스냅샷을 적용
                
            case .failure(let error):
                print("포스팅을 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - PhotoCollectionViewCell

final class PhotoCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
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
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
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
    
    // MARK: - Configure
    
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

        // 이미지의 가로 세로 비율에 따라 제약 조건을 다시 설정합니다.
        photoImageView.snp.remakeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(photoImageView.snp.width).multipliedBy(1/aspectRatio)
        }

        // 레이아웃 변경 사항을 반영하기 위해 컬렉션 뷰의 배치를 업데이트합니다.
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = UIImage(named: "기본냥멍2")
        nameLabel.text = nil
    }
}

// MARK: - Models

import Foundation

struct Photo: Hashable {
    let id: String
    let user: User
    let imageUrls: [String]  // 이미지 URL 리스트를 추가
}

struct User: Hashable {
    let name: String
}
