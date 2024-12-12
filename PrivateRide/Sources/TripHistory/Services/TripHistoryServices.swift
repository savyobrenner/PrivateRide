//
//  TripHistoryServices.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

import Foundation

final class TripHistoryServices: TripHistoryServicesProtocol {

    private let network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func getTripsHistory(id: String, driverId: String) async throws -> RouteResponse {
        let response = try await network.sendRequest(
            endpoint: TripsHistoryEndpoint.tripsHistory(userId: id, driverId: driverId),
            responseModel: RouteResponse.self
        )

        return response
    }
}
