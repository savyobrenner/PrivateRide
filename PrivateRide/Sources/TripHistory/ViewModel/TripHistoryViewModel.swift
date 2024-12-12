//
//  TripHistoryViewModel.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

import SwiftUI

class TripHistoryViewModel: BaseViewModel<TripHistoryCoordinator>, TripHistoryViewModelProtocol {

    private let services: TripHistoryServicesProtocol
    
    init(coordinator: TripHistoryCoordinator?, services: TripHistoryServicesProtocol) {
        self.services = services
        
        super.init(coordinator: coordinator)
    }
}
