//
//  HomeEndpoint.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 11/12/24.
//

import Foundation

enum HomeEndpoint {
    case estimateRide(userId: String, origin: String, destination: String)
}

extension HomeEndpoint: Endpoint {
    var path: String {
        switch self {
        case .estimateRide:
            return "ride/estimate"
        }
    }

    var request: HttpMethods {
        switch self {
        case .estimateRide:
            return .post
        }
    }
    
    var requestSpecificHeaders: [String: String] {
        switch self {
        case .estimateRide:
            return ["Content-Type": "application/json"]
        }
    }
    
    var queryParameters: [URLQueryItem] {
        return []
    }
    
    var bodyParameters: [String : Any]? {
        switch self {
        case let .estimateRide(id, origin, destination):
            return [
                "customer_id": id,
                "origin": origin,
                "destination": destination
            ]
        }
    }
}
