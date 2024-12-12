//
//  MockHomeCoordinator.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

@testable import PrivateRide

final class MockHomeCoordinator: HomeCoordinator {
    var didNavigateToTripsHistory = false
    
    override func navigate(to path: Navigation) {
        switch path {
        case .tripsHistory:
            didNavigateToTripsHistory = true
        }
    }
}
