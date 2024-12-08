//
//  SplashViewModel.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import SwiftUI

class SplashViewModel: BaseViewModel<SplashCoordinator>, SplashViewModelProtocol {
    
    private var user: String? {
        serviceLocator.userSettings.user
    }
    
    let serviceLocator: ServiceLocatorProtocol
    
    init(coordinator: SplashCoordinator?, serviceLocator: ServiceLocatorProtocol) {
        self.serviceLocator = serviceLocator
        
        super.init(coordinator: coordinator)
    }
    
    func load() {

    }
}
