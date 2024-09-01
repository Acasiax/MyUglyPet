//
//  HomeViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// 델리게이트 프로토콜 정의
protocol AllPostTableViewCellDelegate: AnyObject {
    func didTapCommentButton(in cell: AllPostTableViewCell)
    func didTapDeleteButton(in cell: AllPostTableViewCell)
}


final class AllPostHomeViewController: UIViewController {
    
     var serverPosts: [PostsModel] = []
    private let disposeBag = DisposeBag()
    var myProfile: MyProfileResponse?
    private let viewModel = AllPostHomeViewModel()
    
    let colors: [UIColor] = [
        CustomColors.softBlue
    ]
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.backgroundColor = UIColor(red: 1.00, green: 0.74, blue: 0.40, alpha: 1.00)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AllPostTableViewCell.self, forCellReuseIdentifier: AllPostTableViewCell.identifier)
        tableView.backgroundColor = CustomColors.softIvory
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let panGestureRecognizer = UIPanGestureRecognizer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    deinit {
     //   print("AllPostHomeViewController deinitialized")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(plusButton)
        tableView.delegate = self
        tableView.dataSource = self
        configureConstraints()
        
        panGestureRecognizer.delegate = self
        tableView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupBindings() {
        let input = AllPostHomeViewModel.Input(
            plusButtonTap: plusButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.navigateToCreatePost
            .drive(with: self) { owner, _ in
                owner.handlePlusButtonTap()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.bottom.right.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func handlePlusButtonTap() {
        print("게시글 추가 + 버튼 탭")
        AnimationZip.animateButtonPress(plusButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let postCreationVC = CreatePostViewController()
            self.navigationController?.pushViewController(postCreationVC, animated: true)
        }
    }
    
    private func loadData() {
        fetchPosts()
        fetchMyProfile()
    }
}

extension AllPostHomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension AllPostHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllPostTableViewCell.identifier, for: indexPath) as! AllPostTableViewCell
        
        let post = serverPosts[indexPath.row]
        cell.configure(with: post, myProfile: myProfile, color: colors[indexPath.row % colors.count])
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        let selectedPost = serverPosts[indexPath.row]
        
        detailViewController.post = selectedPost
        detailViewController.comments = selectedPost.comments
        detailViewController.imageFiles = selectedPost.files ?? []
        detailViewController.postId = selectedPost.postId
        detailViewController.userName = selectedPost.creator.nick
        detailViewController.titleText = selectedPost.title
        
        if let firstComment = selectedPost.comments.first {
            detailViewController.commentId = firstComment.commentId
        } else {
            detailViewController.commentId = nil
        }
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension AllPostHomeViewController: AllPostTableViewCellDelegate {
    func didTapCommentButton(in cell: AllPostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let detailViewController = DetailViewController()
        detailViewController.title = "Post Detail \(indexPath.row + 1)"
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func didTapDeleteButton(in cell: AllPostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        serverPosts.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

