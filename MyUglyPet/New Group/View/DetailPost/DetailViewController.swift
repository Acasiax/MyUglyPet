//
//  DetailViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/14/24.
//

import UIKit
import SnapKit
import Kingfisher

struct DummyComment {
    let profileImage: UIImage?
    let username: String
    let date: String
    let text: String
}

final class DetailViewController: BaseDetailView {

    
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
        
        // 전달받은 포스트 데이터를 UI에 반영
               if let post = post {
                   contentLabel.text = post.content
                   // 추가적으로 titleLabel, userNameLabel 등에도 포스트 데이터를 반영할 수 있음
               }

               collectionView.reloadData() // 컬렉션뷰 리로드
    }
}


//사진 컬렉션뷰
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageFiles.count <= 2 {
            return imageFiles.count
        } else {
            return 3
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPhotoCollectionViewCell.identifier, for: indexPath) as! DetailPhotoCollectionViewCell
        
        // 이미지 URL을 가져옴
        let imageURLString = imageFiles[indexPath.item]
        let fullImageURLString = APIKey.baseURL + "v1/" + imageURLString
        
        if let imageURL = URL(string: fullImageURLString) {
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
                    print("이미지 로드 실패📍: \(error.localizedDescription)")
                }
            }
        } else {
            print("URL 변환에 실패했습니다: \(fullImageURLString)")
        }
        
        // 이미지 파일 수에 따른 추가 설정
        if indexPath.item < 2 {
            // 첫 두 개의 이미지 설정
            cell.configure(with: cell.imageView.image)
        } else if indexPath.item == 2 && imageFiles.count > 2 {
            // 남은 이미지 개수 표시
            let remainingCount = imageFiles.count - 2
            cell.configure(with: cell.imageView.image, overlayText: "+\(remainingCount)")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let deepPhotoVC = DeepPhotoViewController()
        
        // 이미지 파일의 전체 URL을 생성하여 deepPhotoVC에 전달
        deepPhotoVC.photos = imageFiles.map { file in
            return APIKey.baseURL + "v1/" + file
        }
        
        // 선택한 인덱스를 deepPhotoVC에 전달
        deepPhotoVC.selectedIndex = indexPath.item
        
        // deepPhotoVC로 화면 전환
        navigationController?.pushViewController(deepPhotoVC, animated: true)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        
        if imageFiles.count == 1 {
            // 이미지가 1개일 때는 전체 컬렉션뷰의 너비를 사용
            return CGSize(width: collectionViewWidth, height: 200)
        } else if imageFiles.count == 2 {
            // 이미지가 2개일 때는 각각 절반 너비를 사용
            return CGSize(width: collectionViewWidth / 2, height: 200)
        } else {
            // 이미지가 3개 이상일 때는 기본 크기를 사용
            return CGSize(width: collectionViewWidth / 3, height: 200)
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
