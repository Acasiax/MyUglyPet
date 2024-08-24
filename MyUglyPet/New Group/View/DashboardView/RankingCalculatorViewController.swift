//
//  RankingCalculatorViewController.swift
//  MyUglyPet
//
//  Created by 이윤지 on 8/21/24.
//

import UIKit
import Alamofire
import Kingfisher


struct FetchHashtagReadingPostQuery: Encodable {
    let next: String?
    let limit: String
    let product_id: String
    let hashTag: String?
}
