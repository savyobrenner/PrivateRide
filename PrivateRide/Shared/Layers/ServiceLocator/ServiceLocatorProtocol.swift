//
//  ServiceLocatorProtocol.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

protocol ServiceLocatorProtocol {
    var network: NetworkProtocol { get }
    var cacheManager: CacheManagerProtocol { get }
    var userSettings: UserSettingsProtocol { get }
}

