//
//  LoginQuery.swift
//  SeSAC5LSLPPractice
//
//  Created by jack on 7/25/24.
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
        Mission(iconName: "icon1", title: "웃긴 사진 월드컵 대회참여하기", carrotCount: 2),
        Mission(iconName: "icon2", title: "후보 구경하기", carrotCount: 3),
        Mission(iconName: "icon1", title: "개발자 집 사주기", carrotCount: 2)
    ]
}

struct Pet {
    let name: String
    let userName: String
    let imageURL: String
}






//import UIKit
//import Alamofire
//
//struct UserProfileResponse: Decodable {
//    let userId: String
//    let nick: String
//    let profileImage: String
//    let followers: [Follower]
//    let following: [Following]
//    let posts: [String]
//
//    struct Follower: Decodable {
//        let userId: String
//        let nick: String
//        let profileImage: String
//    }
//
//    struct Following: Decodable {
//        let userId: String
//        let nick: String
//        let profileImage: String
//    }
//}



struct ServerResponse: Decodable {
    let message: String
}

