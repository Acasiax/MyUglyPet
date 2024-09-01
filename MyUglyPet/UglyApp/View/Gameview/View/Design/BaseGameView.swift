//
//  BaseGameView.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/16/24.
//

import UIKit
import SnapKit
import Lottie

struct UIGameView {

    static let basicLottieAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "yellowani")
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        return animationView
    }()

    static let pinkLottieAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "PinkLightEffect")
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.isHidden = true
        return animationView
    }()

    static let congratulationAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "Congratulation")
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.isHidden = true
        return animationView
    }()

    static let worldCupLabel: UILabel = {
        let label = UILabel()
        label.text = "웃긴 사진 월드컵"
        label.backgroundColor = CustomColors.softPink
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.layer.cornerRadius = 13
        label.clipsToBounds = true
        return label
    }()

    static let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "둘 중에 \n 더 웃긴 사진을 골라보세요!"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    static let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "웃긴 사진 월드컵 32강"
        label.backgroundColor = CustomColors.softPink
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.layer.cornerRadius = 17
        label.clipsToBounds = true
        return label
    }()

    static let submitWinnerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("실시간 랭킹에 반영 할래요", for: .normal)
        button.backgroundColor = CustomColors.softPink
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.isHidden = true
        return button
    }()

    static let firstContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.softPurple
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        return view
    }()

    static let firstImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "star")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()

    static let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "벼루님"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    static let firstPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "냥생 3개월차"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()

    static let secondContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.softBlue
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        return view
    }()

    static let secondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "figure.stand")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()

    static let secondNameLabel: UILabel = {
        let label = UILabel()
        label.text = "꼬질이님"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    static let secondPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "견생 5년차"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()

    static let vsLabel: UILabel = {
        let label = UILabel()
        label.text = "VS"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.backgroundColor = .systemBlue
        label.textColor = .white
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
    }()

    static let winnerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가장 웃긴 사진의\n우승자는!!"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    static let winnerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        view.isHidden = true
        return view
    }()

    static let winnerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "star")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()

    static let winnerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "우승자"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    static let winnerAgeLabel: UILabel = {
        let label = UILabel()
        label.text = "나이"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
}
