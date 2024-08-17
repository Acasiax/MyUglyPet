//
//  ScrollViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/17/24.
//

import UIKit
import SnapKit

class ScrollViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let mainHomeViewController = MainHomeViewController()
    private let allPostHomeViewController = AllPostHomeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        addChild(mainHomeViewController)
        contentView.addSubview(mainHomeViewController.view)
        mainHomeViewController.didMove(toParent: self)
        
        addChild(allPostHomeViewController)
        contentView.addSubview(allPostHomeViewController.view)
        allPostHomeViewController.didMove(toParent: self)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(2.0) // 스크롤 가능한 높이 설정
        }
        
        mainHomeViewController.view.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(view.snp.height)
        }
        
        allPostHomeViewController.view.snp.makeConstraints { make in
            make.top.equalTo(mainHomeViewController.view.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(view.snp.height)
        }
    }
}

