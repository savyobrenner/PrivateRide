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
            viewModel: HomeViewModel(coordinator: self, services: Container.shared.homeServices())
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
