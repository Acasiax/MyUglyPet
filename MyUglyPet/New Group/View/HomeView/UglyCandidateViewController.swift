//
//  UglyCandidateViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/20/24.
//

import UIKit
import SnapKit
import PhotosUI
import RxSwift
import RxCocoa
import Alamofire

class UglyCandidateViewController: UIViewController {

    let disposeBag = DisposeBag()
    let viewModel = UglyCandidateViewModel()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "후보를 등록해주세요"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.softPurple
        view.layer.cornerRadius = 20
        return view
    }()
    
    let imageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "기본냥멍3"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 75
        button.clipsToBounds = true
        return button
    }()
    
    let helloNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "사진제목"
        textField.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let subtitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "사용자이름"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.textColor = .gray
        return textField
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("후보에 등록할게요", for: .normal)
        button.backgroundColor = CustomColors.softPink
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    var selectedImage = BehaviorSubject<UIImage?>(value: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
    }

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

    func bindViewModel() {
        let input = UglyCandidateViewModel.Input(
            imageButtonTap: imageButton.rx.tap.asObservable(),
            submitButtonTap: submitButton.rx.tap.asObservable(),
            selectedImage: selectedImage.asObservable(),
            photoTitle: helloNameTextField.rx.text.asObservable(),
            userName: subtitleTextField.rx.text.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.presentImagePicker
            .bind(with: self) { owner, _ in
                owner.presentImagePicker()
            }
            .disposed(by: disposeBag)

        output.validationError
            .bind(with: self) { owner, message in
                owner.showAlert(message: message)
            }
            .disposed(by: disposeBag)

        output.uploadResult
            .bind(with: self) { owner, result in
                switch result {
                case .success:
                    print("업로드 성공")
                    owner.resetForm()
                case .failure(let error):
                    owner.showAlert(message: "업로드 실패: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
    }

    func presentImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func resetForm() {
        helloNameTextField.text = ""
        subtitleTextField.text = ""
        selectedImage.onNext(nil)
        imageButton.setImage(UIImage(named: "기본냥멍3"), for: .normal)
    }
}

// MARK: - PHPicker 사진 선택
extension UglyCandidateViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self else { return }
                
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.selectedImage.onNext(image)
                        self.imageButton.setImage(image, for: .normal)
                    }
                }
            }
        }
    }
}
