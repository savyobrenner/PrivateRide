//
//  MockHomeServices.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

import Foundation
@testable import PrivateRide

final class MockHomeServices: HomeServicesProtocol {
    var shouldFail = false
    var mockEstimateRideResponse: RouteResponse?
    var mockConfirmRideResponse: ConfirmRideResponse?

    var lastEstimateRideRequest: (id: String, origin: String, destination: String)?
    var lastConfirmRideRequest: ConfirmRideRequest?

    func estimateRide(id: String, origin: String, destination: String) async throws -> RouteResponse {
        lastEstimateRideRequest = (id, origin, destination)
        if shouldFail {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to estimate ride"])
        }
        return mockEstimateRideResponse!
    }
    
    func confirmRide(model: ConfirmRideRequest) async throws -> ConfirmRideResponse {
        lastConfirmRideRequest = model
        if shouldFail {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to confirm ride"])
        }
        return mockConfirmRideResponse!
    }
}
