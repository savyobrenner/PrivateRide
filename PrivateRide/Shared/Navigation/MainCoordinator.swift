//
//  MainCoordinator.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import SwiftUI

class MainCoordinator: BaseCoordinator {
    override func start() {
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        childCoordinators.append(splashCoordinator)
        splashCoordinator.start()
    }
}
