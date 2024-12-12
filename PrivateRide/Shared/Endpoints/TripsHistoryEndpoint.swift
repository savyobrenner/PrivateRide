//
//  TripsHistoryEndpoint.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 11/12/24.
//

import Foundation

enum TripsHistoryEndpoint {
    case tripsHistory(userId: String, driverId: String)
}

extension TripsHistoryEndpoint: Endpoint {
    var path: String {
        switch self {
        case let .tripsHistory(userId, _):
            return "ride/\(userId)"
        }
    }

    var request: HttpMethods {
        switch self {
        case .tripsHistory:
            return .get
        }
    }
    
    var requestSpecificHeaders: [String: String] {
        return [:]
    }
    
    var queryParameters: [URLQueryItem] {
        switch self {
        case let .tripsHistory(_, driverId):
            return .init([
                .init(name: "driver_id", value: driverId),
            ])
        }
    }
}
