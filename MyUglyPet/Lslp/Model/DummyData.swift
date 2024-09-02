//
//  DummyData.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//

import Foundation
import UIKit

struct Mission {
    let iconName: String
    let title: String
    let carrotCount: Int
}

struct MissionData {
    static let missions: [Mission] = [
        Mission(iconName: "icon1", title: "웃긴 사진 월드컵 대회참여하기", carrotCount: 1),
        Mission(iconName: "icon2", title: "후보 갯수 확인하기", carrotCount: 2),
        Mission(iconName: "icon1", title: "개발자 집 사주기", carrotCount: 3)
    ]
}

struct Pet {
    let name: String
    let userName: String
    let imageURL: String
}

struct ServerResponse: Decodable {
    let message: String
}

