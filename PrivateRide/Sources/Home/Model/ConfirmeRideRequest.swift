//
//  ConfirmeRideRequest.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 11/12/24.
//

struct ConfirmRideRequest: Codable {
    let customerId: String
    let origin: String
    let destination: String
    let distance: Double
    let duration: String
    let driver: Driver
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case customerId = "customer_id"
        case origin
        case destination
        case distance
        case duration
        case driver
        case value
    }
}

extension ConfirmRideRequest {
    struct Driver: Codable {
        let id: Int
        let name: String
    }
}
