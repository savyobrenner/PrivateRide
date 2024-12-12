//
//  SplashViewModel.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import SwiftUI

class SplashViewModel: BaseViewModel<SplashCoordinator>, SplashViewModelProtocol {
    
    private let analytics: AnalyticsCollectible
    
    init(coordinator: SplashCoordinator?, analytics: AnalyticsCollectible) {
        self.analytics = analytics
        
        super.init(coordinator: coordinator)
    }
    
    func load() {
        analytics.collect(event: PRAnalyticsEvents.appLaunch)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.coordinator?.navigate(to: .home)
        }
    }
}
