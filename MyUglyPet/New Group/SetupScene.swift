//
//  SetupScene.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/18/24.
//

import UIKit

class SetupScene {
    
    static func configure(window: UIWindow?) {
        Appearance.setupTabBarAppearance()
        Appearance.setupNavigationBarAppearance()
        let tabBarController = TabBarControllerFactory.createMainTabBarController()
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
