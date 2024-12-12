//
//  MockTripHistoryServices.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

import Foundation
@testable import PrivateRide

final class MockTripHistoryServices: TripHistoryServicesProtocol {
    var mockTripsResponse: TripHistoryResponse?
    var shouldFail = false
    
    func getTripsHistory(id: String, driverId: Int) async throws -> TripHistoryResponse {
        if shouldFail {
            throw NSError(domain: "Test", code: -1, userInfo: nil)
        }
        return mockTripsResponse!
    }
}
