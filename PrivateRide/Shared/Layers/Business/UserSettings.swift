//
//  UserSettings.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import Factory

protocol UserSettingsProtocol {
    var user: String? { get }
}

class UserSettings: UserSettingsProtocol {
    
    private(set) lazy var user: String? = {
        (try? Container.shared.serviceLocator().cacheManager.fetch(String.self, for: .user))
    }()
}


