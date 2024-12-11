//
//  HomeServicesProtocol.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import Foundation

protocol HomeServicesProtocol {
    func estimateRide(id: String, origin: String, destination: String) async throws -> RouteResponse
    func confirmRide(model: ConfirmRideRequest) async throws -> ConfirmRideResponse
}
