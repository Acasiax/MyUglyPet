//
//  CustomPageControl.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/31/24.
//

import UIKit

class CustomPageControl: UIView {
    
    private var stackView = UIStackView()
    private var indicators = [UIImageView]()
    
    var numberOfPages: Int = 0 {
        didSet {
            setupIndicators()
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            updateIndicators()
        }
    }
    
    var currentPageImage: UIImage?
    var pageImage: UIImage?
    var indicatorTintColor: UIColor = .gray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupIndicators() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        indicators.removeAll()
        
        for _ in 0..<numberOfPages {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = indicatorTintColor
            imageView.image = pageImage
            indicators.append(imageView)
            stackView.addArrangedSubview(imageView)
        }
        
        updateIndicators()
    }
    
    private func updateIndicators() {
        for (index, imageView) in indicators.enumerated() {
            imageView.image = index == currentPage ? currentPageImage : pageImage
        }
    }
}
