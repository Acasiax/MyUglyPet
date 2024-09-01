//
//  Protocol+.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/17/24.
//

import UIKit

protocol ReusableIdentifier {
    static var identifier: String { get }
}

extension UIView: ReusableIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}
