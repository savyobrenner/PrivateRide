//
//  TripHistoryViewModel.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

import SwiftUI

class TripHistoryViewModel: BaseViewModel<TripHistoryCoordinator>, TripHistoryViewModelProtocol {
    @Published
    var userId: String = "" {
        didSet {
            validateFields()
        }
    }
    
    @Published
    var selectedDriverID: Int? {
        didSet {
            validateFields()
        }
    }
    
    var drivers: [ConfirmRideRequest.Driver] {
        return [
            .init(id: 1, name: "Homer Simpson"),
            .init(id: 2, name: "Dominic Toretto"),
            .init(id: 3, name: "James Bond")
        ]
    }
    
    @Published
    var trips: [String] = []
    
    @Published
    var isButtonEnabled = false

    private let services: TripHistoryServicesProtocol
    
    init(coordinator: TripHistoryCoordinator?, services: TripHistoryServicesProtocol) {
        self.services = services
        
        super.init(coordinator: coordinator)
    }
    
    func searchTrips() {
        guard !isLoading, !userId.trimmed.isEmpty, let driverID = selectedDriverID else { return }
        
        isLoading = true
        
        coordinator?.autoCancellingTask { @MainActor in
            defer { self.isLoading = false }
            
            do {
                let response = try await self.services.getTripsHistory(id: self.userId, driverId: driverID)
                
                print(response)
            } catch {
                self.handleNetworkError(error)
            }
        }
    }
}

// MARK: - Private Methods
private extension TripHistoryViewModel {
    func validateFields() {
        isButtonEnabled = !userId.trimmed.isEmpty && selectedDriverID != nil
    }
}
