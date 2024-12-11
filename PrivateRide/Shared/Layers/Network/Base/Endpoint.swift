//
//  Endpoint.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import SwiftUI

protocol Endpoint {
    var url: URL? { get }
    var host: String { get }
    var path: String { get }
    var requestSpecificHeaders: [String: String] { get }
    var request: HttpMethods { get }
    var queryParameters: [URLQueryItem] { get }
    var bodyParameters: [String: Any]? { get }
}

// MARK: - Default
extension Endpoint {
    var host: String { AppEnvironment.baseURL }
    
    var url: URL? {
        .init(string: "\(host)/\(path)/")
    }
    
    var bodyParameters: [String: Any]? { nil }
}
