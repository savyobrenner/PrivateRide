//
//  SplashViewModel.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import SwiftUI

class SplashViewModel: BaseViewModel<SplashCoordinator>, SplashViewModelProtocol {
        
    override init(coordinator: SplashCoordinator?) {
        
        super.init(coordinator: coordinator)
    }
    
    func load() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.coordinator?.navigate(to: .home)
        }
    }
}
