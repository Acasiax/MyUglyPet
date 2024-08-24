//
//  UserDefaultsManager.swift
//  SeSAC5LSLPPractice
//
//  Created by jack on 7/25/24.
//

import Foundation

final class UserDefaultsManager {
    
    private enum UserDefaultsKey: String {
        case access
        case refresh
        case id
    }
    
    static let shared = UserDefaultsManager()
    
    private init() { }
    
    var token: String {
        get {
            UserDefaults.standard.string(
                forKey: UserDefaultsKey.access.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.access.rawValue)
        }
    }
    
    var refreshToken: String {
        get {
            UserDefaults.standard.string(
                forKey: UserDefaultsKey.refresh.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.refresh.rawValue)
        }
    }
    
    var id: String {
        get {
            UserDefaults.standard.string(
                forKey: UserDefaultsKey.id.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.id.rawValue)
        }
    }
}
