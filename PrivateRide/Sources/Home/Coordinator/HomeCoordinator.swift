//
//  HomeCoordinator.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import Factory
import SwiftUI

class HomeCoordinator: BaseCoordinator {
    
    override func start() {
        let viewcontroller = HomeView(
            viewModel: HomeViewModel(
                coordinator: self,
                services: Container.shared.homeServices(),
                analytics: Container.shared.analyticsCollector()
            )
        )
            .insideHostingController()
        
        navigationController.setViewControllers([viewcontroller], animated: false)
    }
    
    enum Navigation {
        case tripsHistory
    }
    
    func navigate(to path: Navigation) {
        switch path {
        case .tripsHistory:
            present(TripHistoryCoordinator.init(navigationController: .init()), animated: true)
        }
    }
}
