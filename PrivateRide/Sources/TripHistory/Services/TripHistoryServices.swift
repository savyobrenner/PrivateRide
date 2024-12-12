//
//  TripHistoryServices.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

import Foundation

final class TripHistoryServices: TripHistoryServicesProtocol {

    private let network: NetworkClient

    init(network: NetworkClient) {
        self.network = network
    }
}
