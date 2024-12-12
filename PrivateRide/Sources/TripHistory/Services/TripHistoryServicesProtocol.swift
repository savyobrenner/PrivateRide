//
//  TripHistoryServicesProtocol.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

import Foundation

protocol TripHistoryServicesProtocol {
    func getTripsHistory(id: String, driverId: Int) async throws -> TripHistoryResponse
}
