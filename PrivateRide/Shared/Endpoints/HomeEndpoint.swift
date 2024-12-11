//
//  HomeEndpoint.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 11/12/24.
//

import Foundation

enum HomeEndpoint {
    case estimateRide(userId: String, origin: String, destination: String)
    case confirmRide(model: ConfirmeRideRequest)
}

extension HomeEndpoint: Endpoint {
    var path: String {
        switch self {
        case .estimateRide:
            return "ride/estimate"
        case .confirmRide:
            return "ride/confirm"
        }
    }

    var request: HttpMethods {
        switch self {
        case .estimateRide:
            return .post
        case .confirmRide:
            return .patch
        }
    }
    
    var requestSpecificHeaders: [String: String] {
        switch self {
        case .estimateRide, .confirmRide:
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
        case let .confirmRide(model):
            return model.asDictionary()
        }
    }
}
