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
            viewModel: TripHistoryViewModel(coordinator: self)
        )
            .insideHostingController()
        
        navigationController.setViewControllers([viewcontroller], animated: false)
    }
    
    enum Navigation {
        case home
    }
    
    func navigate(to path: Navigation) {
        switch path {
        case .home: break
        }
    }
}
