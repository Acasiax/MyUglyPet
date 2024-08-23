//
//  TabBarController.swift
//  MusicSpot
//
//  Created by 이윤지 on 8/9/24.
//

import UIKit

// MARK: - MainTab 열거형
enum MainTab: CaseIterable {
    case music
    case movies
    case podcast
    case books
    case search

    // MARK: - 제목
    var title: String {
        switch self {
        case .music: return "커뮤니티"
        case .movies: return "홈,게임"
        case .podcast: return "포스팅하기"
        case .books: return "앨범"
        case .search: return "프로필설정"
        }
    }

    // MARK: - 아이콘
    var image: UIImage? {
        switch self {
        case .music: return UIImage(systemName: "pawprint")
        case .movies: return UIImage(systemName: "house")
        case .podcast: return UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
        case .books: return UIImage(systemName: "book.closed")
        case .search: return UIImage(systemName: "person")
        }
    }

    // MARK: - 뷰 컨트롤러
    var viewController: UIViewController {
        let viewController: UIViewController
        switch self {
        case .music: viewController = MainHomeViewController()
        case .movies: viewController = AllPostHomeViewController()
        case .podcast: viewController = DashboardViewController()
        case .books: viewController = NameInputViewController()
        case .search: viewController = UglyCandidateViewController()
        }
        
        let navController = UINavigationController(rootViewController: viewController)
               navController.tabBarItem = UITabBarItem(title: self.title, image: self.image, tag: self.hashValue)
               return navController
    }
}

// MARK: - TabBarControllerFactory 클래스
class TabBarControllerFactory {
    static func createMainTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        // 특정 조건에 따라 TabBar의 순서를 변경할 수 있도록 유연하게 설정
        var viewControllers = [UIViewController]()
        let tabs: [MainTab] = [.music, .movies, .podcast, .books, .search]

        for tab in tabs {
            viewControllers.append(tab.viewController)
        }

        tabBarController.viewControllers = viewControllers
        return tabBarController
    }
}


// MARK: - Appearance 스트럭트
struct Appearance {
    static func setupTabBarAppearance() {
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().backgroundColor = .white
    }
    
    static func setupNavigationBarAppearance() {
        UINavigationBar.appearance().barTintColor = CustomColors.softBlue
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().backgroundColor = CustomColors.softPurple
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: CustomColors.softPink]
        
        let backBarButtonItem = UIBarButtonItem.appearance()
        backBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        backBarButtonItem.title = ""
    }
}
