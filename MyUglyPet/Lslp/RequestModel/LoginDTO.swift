//
//  LoginDTO.swift
//  MyUglyPet
//
//  Created by 이윤지 on 9/1/24.
//

import Foundation

struct LoginQuery: Encodable {
    let email: String
    let password: String
}
