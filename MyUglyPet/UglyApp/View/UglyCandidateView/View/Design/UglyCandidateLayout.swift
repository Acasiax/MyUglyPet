//
//  UglyCandidateLayout.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/25/24.
//

import Foundation

extension UglyCandidateViewController {
    func setupViews() {
        view.backgroundColor = CustomColors.lightBeige
        view.addSubview(titleLabel)
        view.addSubview(containerView)
        containerView.addSubview(imageButton)
        containerView.addSubview(helloNameTextField)
        containerView.addSubview(subtitleTextField)
        view.addSubview(submitButton)
    }

    
    func setupConstraints() {
           titleLabel.snp.makeConstraints { make in
               make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
               make.left.right.equalTo(view).inset(20)
           }

           containerView.snp.makeConstraints { make in
               make.centerX.equalToSuperview()
               make.width.equalTo(250)
               make.height.equalTo(300)
               make.centerY.equalToSuperview().offset(-20)
           }
           
           imageButton.snp.makeConstraints { make in
               make.top.equalTo(containerView.snp.top).offset(20)
               make.centerX.equalToSuperview()
               make.width.height.equalTo(150)
           }

           helloNameTextField.snp.makeConstraints { make in
               make.top.equalTo(imageButton.snp.bottom).offset(15)
               make.centerX.equalToSuperview()
               make.width.equalTo(200)
           }

           subtitleTextField.snp.makeConstraints { make in
               make.top.equalTo(helloNameTextField.snp.bottom).offset(8)
               make.centerX.equalToSuperview()
               make.width.equalTo(200)
           }

           submitButton.snp.makeConstraints { make in
               make.top.equalTo(containerView.snp.bottom).offset(40)
               make.centerX.equalToSuperview()
           }
       }
    
}
