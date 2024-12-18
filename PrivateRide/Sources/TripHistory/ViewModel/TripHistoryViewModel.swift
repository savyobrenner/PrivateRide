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
    var trips: [PRTripCard.Model] = []
    
    @Published
    var isButtonEnabled = false
    
    @Published
    var firstLoad = true

    private let services: TripHistoryServicesProtocol
    private let analytics: AnalyticsCollectible
    
    init(coordinator: TripHistoryCoordinator?, services: TripHistoryServicesProtocol, analytics: AnalyticsCollectible) {
        self.services = services
        self.analytics = analytics
        
        super.init(coordinator: coordinator)
        
        analytics.collect(event: PRAnalyticsEvents.tripHistoryScreen)
    }
    
    func searchTrips() {
        guard !isLoading, !userId.trimmed.isEmpty, let driverID = selectedDriverID else { return }
        
        isLoading = true
        
        coordinator?.autoCancellingTask { @MainActor in
            defer { self.isLoading = false }
            
            do {
                let response = try await self.services.getTripsHistory(id: self.userId, driverId: driverID)
                
                let trips: [PRTripCard.Model] = response.rides.compactMap { trip in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    
                    let date = formatter.date(from: trip.date) ?? Date()
                    
                    formatter.dateFormat = "MMM d, yyyy 'at' HH:mm"
                    let dateString = formatter.string(from: date)

                    let durationComponents = trip.duration.components(separatedBy: ":")
                    var durationMinutes = 0
                    if durationComponents.count == 2 {
                        if let minutes = Int(durationComponents[0]), let seconds = Int(durationComponents[1]) {
                            durationMinutes = abs(minutes + seconds / 60)
                        }
                    }
                    
                    let minutesText = "minutes".localized
                    let formattedDistance = "\(String(format: "%.2f", trip.distance)) km | \(durationMinutes) \(minutesText)"
                    let formattedValue = "R$ \(String(format: "%.2f", trip.value))"

                    return .init(
                        date: dateString,
                        origin: trip.origin,
                        destination: trip.destination,
                        driverName: trip.driver.name,
                        value: formattedValue,
                        distance: formattedDistance
                    )
                }
                
                self.trips = trips
                
                self.firstLoad = false
            } catch {
                self.firstLoad = false
                self.trips = []
                
                self.handleNetworkError(error)
            }
        }
    }
    
    override func dismiss(animated: Bool = true) {
        analytics.collect(event: PRAnalyticsEvents.tripHistoryBackButton)
        analytics.collect(event: PRAnalyticsEvents.tripHistoryScreenTime(duration: screenTime))
        
        coordinator?.dismiss(animated: animated)
    }
    
    func validateFields() {
        isButtonEnabled = !userId.trimmed.isEmpty && selectedDriverID != nil
    }
}
