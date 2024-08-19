//
//  HomeViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/14/24.
//

import UIKit
import SnapKit
import Kingfisher

struct FetchReadingPostQuery: Encodable {
    let next: String?
    let limit: String
    let product_id: String
    
}


// 델리게이트 프로토콜 정의
protocol AllPostTableViewCellDelegate: AnyObject {
    func didTapCommentButton(in cell: AllPostTableViewCell)
}

final class AllPostHomeViewController: UIViewController {
    
    private var posts: [PostsModel] = []
    
    let colors: [UIColor] = [
           CustomColors.deepPurple,
           UIColor(red: 1.00, green: 0.78, blue: 0.87, alpha: 1.00),
           UIColor(red: 0.73, green: 0.96, blue: 0.48, alpha: 1.00),
           CustomColors.softPink,
           CustomColors.softBlue,
           CustomColors.softPurple
           
       ]
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AllPostTableViewCell.self, forCellReuseIdentifier: AllPostTableViewCell.identifier)
        tableView.backgroundColor = CustomColors.lightBeige
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private let panGestureRecognizer = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubview(tableView)
        view.addSubview(plusButton)
        tableView.delegate = self
        tableView.dataSource = self
        configureConstraints()
        
        // 데이터 로드
               fetchPosts()
        
        // Pan Gesture Recognizer를 tableView에 추가
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture))
        panGestureRecognizer.delegate = self // 델리게이트 설정
        tableView.addGestureRecognizer(panGestureRecognizer)
    }

    deinit {
           print("AllPostHomeView 디이닛")
       }
    
    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
           // make.top.equalToSuperview().offset(20)
        }
        
        plusButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.bottom.right.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    
    private func fetchPosts() {
        // 쿼리 파라미터 생성
        let query = FetchReadingPostQuery(next: nil, limit: "20", product_id: "")

        // 네트워크 요청 예시 (PostNetworkManager 사용)
        PostNetworkManager.shared.fetchPosts(query: query) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
                self?.tableView.reloadData() // 데이터 로드 후 테이블뷰 리로드
                print("포스팅을 가져오는데 성공했어요🥰")
            case .failure(let error):
                print("포스팅을 가져오는데 실패했어요🥺ㅠㅜ: \(error.localizedDescription)")
            }
        }
    }

    
    @objc private func plusButtonTapped() {
        print("게시글추가 +버튼 탭")
        AnimationZip.animateButtonPress(plusButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let postCreationVC = CreatePostViewController()
            self.navigationController?.pushViewController(postCreationVC, animated: true)
        }
    }
    

    // Pan Gesture 처리
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        if gesture.state == .changed {
            if translation.y > 0 { // 아래로 스와이프 중이면 (y가 양수)
                view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        } else if gesture.state == .ended {
            if translation.y > 100 { // 사용자가 충분히 아래로 스와이프했을 때
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
                }) { _ in
                    // 현재 뷰 컨트롤러를 닫고 이전 화면으로 돌아갑니다.
                    self.dismiss(animated: true) {
                        self.view.transform = .identity
                    }
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                }
            }
        }
    }

    
    
    
}

extension AllPostHomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


extension AllPostHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print("헬로우 포스트 갯수: \(posts.count)")
        return posts.count // 포스트 개수만큼 반환
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllPostTableViewCell.identifier, for: indexPath) as! AllPostTableViewCell
        
        let post = posts[indexPath.row]
        cell.titleLabel.text = post.title // 포스트 제목 설정
        cell.contentLabel.text = post.content // 포스트 내용 설정
        cell.imageFiles = post.files ?? [] // 이미지 URL 배열 전달
        cell.delegate = self  // 델리게이트 설정
        
        let colorIndex = indexPath.row % colors.count
        cell.containerView.backgroundColor = colors[colorIndex]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.title = posts[indexPath.row].title // 제목 설정
        detailViewController.post = posts[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}


// 델리게이트 메서드 구현
extension AllPostHomeViewController: AllPostTableViewCellDelegate {
    func didTapCommentButton(in cell: AllPostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let detailViewController = DetailViewController()
        detailViewController.title = "Post Detail \(indexPath.row + 1)"
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}



class PostCollectionViewCell: UICollectionViewCell {

    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "기본냥멍2")
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    private func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


//extension AllPostHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
//        
//      
//        cell.imageView.backgroundColor = .blue
//        
//        let imageURLString = imageFiles[indexPath.item]
//               if let imageURL = URL(string: imageURLString) {
//                   // Kingfisher를 사용하여 이미지 로드
//                   cell.imageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
//               }
//        
//        return cell
//    }
//    
//    // 셀의 크기를 컬렉션 뷰의 크기에 맞춤
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
//    }
//}
