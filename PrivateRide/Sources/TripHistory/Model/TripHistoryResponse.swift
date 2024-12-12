//
//  TripHistoryResponse.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

struct TripHistoryResponse: Codable {
    let customerId: String
    let rides: [Trip]
    
    enum CodingKeys: String, CodingKey {
        case customerId = "customer_id"
        case rides
    }
    
    init(customerId: String, rides: [Trip]) {
        self.customerId = customerId
        self.rides = rides
    }
}

extension TripHistoryResponse {
    struct Trip: Codable {
        let id: Int
        let date: String
        let origin: String
        let destination: String
        let distance: Double
        let duration: String
        let driver: ConfirmRideRequest.Driver
        let value: Double
    }
}
