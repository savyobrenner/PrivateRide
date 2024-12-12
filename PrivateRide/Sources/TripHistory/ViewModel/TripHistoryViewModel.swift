//
//  TripHistoryViewModel.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

import SwiftUI

class TripHistoryViewModel: BaseViewModel<TripHistoryCoordinator>, TripHistoryViewModelProtocol {
    @Published
    var userId: String = ""
    
    @Published
    var selectedDriverID: Int?
    
    @Published
    var drivers: [ConfirmRideRequest.Driver] = []
    
    @Published
    var trips: [String] = []
    
    @Published
    var isButtonEnabled = true

    private let services: TripHistoryServicesProtocol
    
    init(coordinator: TripHistoryCoordinator?, services: TripHistoryServicesProtocol) {
        self.services = services
        
        super.init(coordinator: coordinator)
    }
    
    func searchTrips() {
        
    }
}
