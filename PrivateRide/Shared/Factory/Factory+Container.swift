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
    
    var cacheManager: Factory<CacheManagerProtocol> {
        self { CacheManager() }
    }
    
    var userSettings: Factory<UserSettingsProtocol> {
        self { UserSettings() }
    }
    
    var serviceLocator: Factory<ServiceLocatorProtocol> {
        self {
            ServiceLocator(
                network: self.networkService.resolve(),
                cacheManager: self.cacheManager.resolve(),
                userSettings: self.userSettings.resolve()
            )
        }.singleton
    }
}

