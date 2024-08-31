//
//  BaseAllPostHomeView.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/31/24.
//

import UIKit

class BaseAllPostHomeView: UIViewController {
    
//MARK: - 변수 설정
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseUI()
    }

    //MARK: - UI랑 제약조건 설정
    private func setupBaseUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(plusButton)
        setupBaseConstraints()
    }

    private func setupBaseConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.bottom.right.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
