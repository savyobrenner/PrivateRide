//
//  HomeServices.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import Foundation

final class HomeServices: HomeServicesProtocol {

    private let network: NetworkClient

    init(network: NetworkClient) {
        self.network = network
    }
}
