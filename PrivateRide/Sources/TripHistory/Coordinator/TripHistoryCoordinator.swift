//
//  TripHistoryCoordinator.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

import Factory
import SwiftUI

class TripHistoryCoordinator: BaseCoordinator {
    
    override func start() {
        let viewcontroller = TripHistoryView(
            viewModel: TripHistoryViewModel(
                coordinator: self,
                services: Container.shared.tripHistoryServices(),
                analytics: Container.shared.analyticsCollector()
            )
        )
            .insideHostingController()
        
        navigationController.pushViewController(viewcontroller, animated: true)
    }
}
