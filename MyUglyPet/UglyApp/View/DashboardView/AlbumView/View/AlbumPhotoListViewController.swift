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


// MARK: - 사진 정보

import Foundation

struct Photo: Hashable {
    let id: String
    let user: User
    let imageUrls: [String]
}

struct User: Hashable {
    let name: String
}
