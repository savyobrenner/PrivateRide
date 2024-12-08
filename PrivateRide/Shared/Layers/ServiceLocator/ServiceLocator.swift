//
//  ServiceLocator.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import Foundation

final class ServiceLocator: ServiceLocatorProtocol {
    
    var network: NetworkProtocol
    var cacheManager: CacheManagerProtocol
    var userSettings: UserSettingsProtocol
    
    init(network: NetworkProtocol,
         cacheManager: CacheManagerProtocol,
         userSettings: UserSettingsProtocol) {
        self.network = network
        self.cacheManager = cacheManager
        self.userSettings = userSettings
    }
}

