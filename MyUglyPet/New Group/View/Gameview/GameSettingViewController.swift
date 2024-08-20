//
//  GameSettingViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/21/24.
//

//import UIKit
//
//protocol GameSettingViewControllerDelegate: AnyObject {
//    func didFetchPosts(_ posts: [PostsModel])
//}
//
//class GameSettingViewController: UIViewController {
//
//    weak var delegate: GameSettingViewControllerDelegate?
//    private var serverUglyCandidatePosts: [PostsModel] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        fetchPosts()
//    }
//
//    private func fetchPosts() {
//        let query = FetchReadingPostQuery(next: nil, limit: "30", product_id: "못난이후보등록")
//
//        PostNetworkManager.shared.fetchPosts(query: query) { [weak self] result in
//            switch result {
//            case .success(let posts):
//                self?.serverUglyCandidatePosts = posts
//                self?.shuffleAndSelectPosts()
//                print("🎮게임후보 포스팅을 가져오는데 성공했어요")
//            case .failure(let error):
//                print("🎮게임후보 포스팅을 가져오는데 실패했어요ㅠㅜ: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    private func shuffleAndSelectPosts() {
//        serverUglyCandidatePosts.shuffle()
//        let selectedPosts = Array(serverUglyCandidatePosts.prefix(2))
//        
//        // Delegate 메서드 호출
//        delegate?.didFetchPosts(selectedPosts)
//    }
//}

















//let pets: [Pet] = [
//    Pet(name: "벼루님", hello: "뭘보냥?", image: UIImage(named: "기본냥멍1")!),
//    Pet(name: "꼬질이님", hello: "퇴근후 기절각", image: UIImage(named: "기본냥멍2")!),
//    Pet(name: "3님", hello: "꿀잠이다멍", image: UIImage(named: "기본냥멍3")!),
//    Pet(name: "4님", hello: "멈칫", image: UIImage(named: "기본냥멍4")!),
//    Pet(name: "5님", hello: "식칼어딨어멍멍", image: UIImage(named: "기본냥멍5")!),
//    Pet(name: "6님", hello: "왔냐?", image: UIImage(named: "기본냥멍6")!),
//    Pet(name: "7님", hello: "주인아밥줘라", image: UIImage(named: "기본냥멍7")!),
//]
