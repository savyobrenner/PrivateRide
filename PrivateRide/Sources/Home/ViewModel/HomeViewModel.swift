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
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default Location
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Published
    var userId: String = "" {
        didSet { validateForm() }
    }
    
    @Published
    var currentAddress: String = "" {
        didSet { triggerAutocomplete(for: currentAddress, field: .pickUp) }
    }
    
    @Published
    var dropOffAddress: String = "" {
        didSet { triggerAutocomplete(for: dropOffAddress, field: .dropOff) }
    }
    
    @Published
    var isSwapping = false
    
    @Published
    var isButtonEnabled = false
    
    @Published
    var autocompleteResults: [String] = []
    
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
        guard !currentAddress.isEmpty && !dropOffAddress.isEmpty else { return }
        
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
        print("Searching for ride...")
        // TODO: Implementar lógica de busca de ride
    }
    
    func locateUser() {
        guard let userLocation else { return }
        
        updateRegion(to: userLocation)
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to reverse geocode: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first {
                let address = [
                    placemark.thoroughfare,
                    placemark.subThoroughfare,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.postalCode
                ]
                    .compactMap { $0 }
                    .joined(separator: ", ")
                
                DispatchQueue.main.async {
                    self.currentAddress = address
                }
            }
        }
    }
    
    private func triggerAutocomplete(for query: String, field: PRAddressFormView.Field) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            autocompleteResults = []
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .address
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self else { return }
            if let error = error {
                print("Autocomplete error: \(error.localizedDescription)")
                return
            }
            
            self.autocompleteResults = response?.mapItems.compactMap { $0.placemark.title } ?? []
        }
    }
    
    private func validateForm() {
        isButtonEnabled = !userId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !currentAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !dropOffAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
