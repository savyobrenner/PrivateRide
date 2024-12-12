//
//  Factory+Container.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import Factory

extension Container {
    var networkService: Factory<NetworkProtocol> {
        self { NetworkClient() }
    }
    
    var homeServices: Factory<HomeServicesProtocol> {
        self { HomeServices(network: self.networkService.resolve()) }
    }
    
    var tripHistoryServices: Factory<TripHistoryServicesProtocol> {
        self { TripHistoryServices(network: self.networkService.resolve()) }
    }
    
    var analyticsCollector: Factory<AnalyticsCollectible> {
        self { SimulatedAnalytics() }
    }
}

