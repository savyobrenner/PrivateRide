//
//  HomeViewModel.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import CoreLocation
import MapKit
import SwiftUI

class HomeViewModel: BaseViewModel<HomeCoordinator>, HomeViewModelProtocol {
    @Published
    var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default Value
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)       // Default Zoom
    )
    
    @Published
    var userId: String = "" {
        didSet { validateForm() }
    }
    
    @Published
    var currentAddress: String = "" {
        didSet { validateForm() }
    }
    
    @Published
    var dropOffAddress: String = "" {
        didSet { validateForm() }
    }
    
    @Published
    var isSwapping = false
    
    @Published
    var isButtonEnabled = false
    
    // MARK: - Validators
    private var isUserIdValid: Bool {
        !userId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isCurrentAddressValid: Bool {
        !currentAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isDropOffAddressValid: Bool {
        !dropOffAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var userLocation: CLLocationCoordinate2D? {
        didSet {
            guard let location = userLocation else { return }
            updateRegion(to: location)
        }
    }
    
    private let locationManager = CLLocationManager()
    
    override init(coordinator: HomeCoordinator?) {
        super.init(coordinator: coordinator)
        
        configureLocationManager()
    }
    
    func swapAddresses() {
        guard isCurrentAddressValid && isDropOffAddressValid else { return }
        
        withAnimation {
            isSwapping = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let temp = self.currentAddress
            self.currentAddress = self.dropOffAddress
            self.dropOffAddress = temp
            
            withAnimation {
                self.isSwapping = false
            }
        }
    }
    
    func searchRide() {
        guard isButtonEnabled else { return }
        
        // TODO: Implementar a lógica para buscar rides
    }
    
    func locateUser() {
        guard let userLocation else { return }
        
        updateRegion(to: userLocation)
    }
    
    private func validateForm() {
        isButtonEnabled = isUserIdValid && isCurrentAddressValid && isDropOffAddressValid
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func updateRegion(to location: CLLocationCoordinate2D) {
        withAnimation {
            self.region = MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
    }
}

extension HomeViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}
