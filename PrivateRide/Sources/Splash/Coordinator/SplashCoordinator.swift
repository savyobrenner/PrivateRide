//
//  SplashCoordinator.swift
//  LikeAPPro
//
//  Created by Savyo Brenner on 24/07/24.
//  Copyright © 2024 LikeAPPro Tecnologia. All rights reserved.
//

import Factory
import SwiftUI

class SplashCoordinator: BaseCoordinator {
    
    override func start() {
        let viewcontroller = SplashView(
            viewModel: SplashViewModel(coordinator: self, serviceLocator: Container.shared.serviceLocator())
        )
            .insideHostingController()
        
        navigationController.setViewControllers([viewcontroller], animated: false)
    }
    
    enum Navigation {
        case home
    }
    
    func navigate(to path: Navigation) {
        switch path {
        case .home:
            present(HomeCoordinator(navigationController: .init()), animated: true)
        }
    }
}
