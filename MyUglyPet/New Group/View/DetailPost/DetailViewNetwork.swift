//
//  DetailViewNetwork.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/31/24.
//

import UIKit

// MARK: - 서버 요청 관련 메서드
extension DetailViewController {
    
    func deleteComment(postId: String, commentId: String, at indexPath: IndexPath) {
        PostNetworkManager.shared.deleteComment(postID: postId, commentID: commentId) { [weak self] success, error in
            guard let self = self else { return }
            
            if success {
                self.post?.comments.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                self.showErrorAlert(message: "댓글을 삭제하는 데 실패했습니다. 나중에 다시 시도해주세요.")
            }
        }
    }
    
    func fetchLatestPostData(userID: String) {
        let query = FetchReadingPostQuery(next: nil, limit: "30", product_id: "allFeed")
        
        PostNetworkManager.shared.fetchUserPosts(userID: userID, query: query) { [weak self] result in
            switch result {
            case .success(let updatedPosts):
                self?.post = updatedPosts.first
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showErrorAlert(message: "포스트 데이터를 불러오는 데 실패했습니다. 나중에 다시 시도해주세요.")
            }
        }
    }
    
    func updatePost() {
        guard let postID = post?.postId else { return }
        
        let parameters: [String: Any] = [
            "title": post?.title ?? "",
            "content": post?.content ?? ""
        ]
        
        PostNetworkManager.shared.updatePost(postID: postID, parameters: parameters) { [weak self] result in
            switch result {
            case .success:
                self?.fetchLatestPostData(userID: self?.post?.creator.userId ?? "")
            case .failure(let error):
                self?.showErrorAlert(message: "포스트 수정에 실패했습니다. 나중에 다시 시도해주세요.")
            }
        }
    }
    
    func editComment(commentId: String, newContent: String) {
        guard let postID = post?.postId else { return }
        
        PostNetworkManager.shared.editComment(postID: postID, commentID: commentId, newContent: newContent) { [weak self] result in
            switch result {
            case .success:
                self?.fetchLatestPostData(userID: self?.post?.creator.userId ?? "")
            case .failure(let error):
                self?.showErrorAlert(message: "댓글 수정에 실패했습니다. 나중에 다시 시도해주세요.")
            }
        }
    }
}
