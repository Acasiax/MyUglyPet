//
//  UglyCandidateViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/20/24.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa
import Alamofire

class UglyCandidateViewController: UIViewController {

    let disposeBag = DisposeBag()
    let viewModel = UglyCandidateViewModel()

    let titleLabel = UglyCandidateUI.titleLabel
    let containerView = UglyCandidateUI.containerView
    let imageButton = UglyCandidateUI.imageButton
    let helloNameTextField = UglyCandidateUI.helloNameTextField
    let subtitleTextField = UglyCandidateUI.subtitleTextField
    let submitButton = UglyCandidateUI.submitButton
    
    var selectedImage = BehaviorSubject<UIImage?>(value: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
    }


    // MARK: - rx로 바인딩한거
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

    // MARK: - 이미지 선택 후 초기화 등등
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


