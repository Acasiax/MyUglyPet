//
//  SetupScene.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/18/24.
//
//TabBarControllerFactory.createMainTabBarController()
import UIKit

class SetupScene {
    
    static func configure(window: UIWindow?) {
        Appearance.setupTabBarAppearance()
        Appearance.setupNavigationBarAppearance()
        
        let loginViewController = LoginViewController()
                let navigationController = UINavigationController(rootViewController: loginViewController)
                window?.rootViewController = navigationController
                window?.makeKeyAndVisible()
     
    }
}
