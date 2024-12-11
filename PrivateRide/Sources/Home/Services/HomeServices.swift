//
//  HomeServices.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import Foundation

final class HomeServices: HomeServicesProtocol {
    
    private let network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func estimateRide(id: String, origin: String, destination: String) async throws -> RouteResponse {
        let response = try await network.sendRequest(
            endpoint: HomeEndpoint.estimateRide(userId: id, origin: origin, destination: destination),
            responseModel: RouteResponse.self
        )

        return response
    }
}
