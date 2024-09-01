//
//  BirthdayInputViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/18/24.
//

import UIKit
import SnapKit

class BirthdayInputViewController: UIViewController {
    
    let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 1.00
        progressView.tintColor = UIColor.lightGray
        return progressView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일을 입력해 주세요"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일은 언제든지 수정할 수 있어요"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
        picker.maximumDate = Date() // 오늘 날짜까지만 선택 가능
        picker.date = Calendar.current.date(byAdding: .year, value: -10, to: Date())! // 초기값을 20년 전 날짜로 설정
        return picker
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false // 초기에는 비활성화 상태
        return button
    }()
    
    let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음에 입력하기", for: .normal)
        button.setTitleColor(UIColor.orange, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
       
        view.addSubview(progressBar)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(datePicker)
        view.addSubview(nextButton)
        view.addSubview(skipButton)
        
        
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalTo(view).inset(40)
            make.height.equalTo(2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(30)
            make.left.right.equalTo(view).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalTo(view).inset(20)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.left.right.equalTo(view).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(40)
            make.left.right.equalTo(view).inset(40)
            make.height.equalTo(50)
        }
        
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }
    }
    
    @objc func datePickerValueChanged() {
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor.orange
    }
    
    @objc func nextButtonTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        
        print("선택한 생년월일: \(selectedDate)")
        
        let welcomeVC = WelcomeViewController()
        navigationController?.pushViewController(welcomeVC, animated: true)
    }
}

