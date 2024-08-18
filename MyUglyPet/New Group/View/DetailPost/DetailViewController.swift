//
//  DetailViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/14/24.
//

import UIKit
import SnapKit
//import IQKeyboardManagerSwift

struct DummyComment {
    let profileImage: UIImage?
    let username: String
    let date: String
    let text: String
}

class DetailViewController: BaseDetailView {

    var photos: [UIImage] = [
        UIImage(named: "기본냥멍1")!,
        UIImage(named: "기본냥멍2")!,
        UIImage(named: "기본냥멍3")!,
        UIImage(named: "기본냥멍4")!,
        UIImage(named: "기본냥멍5")!,
        UIImage(named: "기본냥멍6")!
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.lightBeige
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        configureHierarchy()
        configureConstraints()
    } 
}


//사진 컬렉션뷰
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photos.count <= 2 {
            return photos.count
        } else {
            return 3
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPhotoCollectionViewCell.identifier, for: indexPath) as! DetailPhotoCollectionViewCell
        
        if indexPath.item < 2 {
            cell.configure(with: photos[indexPath.item])
        } else if indexPath.item == 2 && photos.count > 2 {
            let remainingCount = photos.count - 2
            cell.configure(with: photos[2], overlayText: "+\(remainingCount)")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let deepPhotoVC = DeepPhotoViewController()
        deepPhotoVC.photos = photos
        deepPhotoVC.selectedIndex = indexPath.item
        navigationController?.pushViewController(deepPhotoVC, animated: true)
    }

    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        
        if photos.count == 1 {
            // 이미지가 1개일 때는 전체 컬렉션뷰의 너비를 사용
            return CGSize(width: collectionViewWidth, height: 200)  // 여기를 200으로 설정해보세요
        } else if photos.count == 2 {
            // 이미지가 2개일 때는 각각 절반 너비를 사용
            return CGSize(width: collectionViewWidth / 2, height: 200)  // 여기를 200으로 설정해보세요
        } else {
            // 이미지가 3개 이상일 때는 기본 크기를 사용 (예: 1/3 너비)
            return CGSize(width: collectionViewWidth / 3, height: 200)  // 여기를 200으로 설정해보세요
        }
    }

}







//댓글 창 테이블뷰
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        
        let comment = comments[indexPath.row]
        cell.configure(with: comment.profileImage, username: comment.username, date: comment.date, comment: comment.text)
        
        return cell
    }
}
