//
//  TargetType.swift
//  SeSAC5LSLPPractice
//
//  Created by jack on 7/25/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var routerbaseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var header: [String: String] { get }
    var parameters: String? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension TargetType {
    
    func asURLRequest() throws -> URLRequest {
        let url = try routerbaseURL.asURL()
        var request = try URLRequest(
            url: url.appendingPathComponent(path),
            method: method)
        request.allHTTPHeaderFields = header
        request.httpBody = body
        //request.httpBody = parameters?.data(using: .utf8)
        return request
    }
    
}
