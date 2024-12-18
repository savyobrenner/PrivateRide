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
    enum Field {
        case pickUp
        case dropOff
    }
    
    // MARK: - Published Properties
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Published var userId: String = "" {
        didSet { validateForm() }
    }
    
    @Published var currentAddress: String = "" {
        didSet {
            checkAndTriggerAutocomplete(for: currentAddress, field: .pickUp)
        }
    }
    
    @Published var dropOffAddress: String = "" {
        didSet {
            checkAndTriggerAutocomplete(for: dropOffAddress, field: .dropOff)
        }
    }
    
    @Published
    var polyline: MKPolyline?
    
    @Published
    var isSwapping = false
    
    @Published
    var isButtonEnabled = false
    
    @Published
    var isAddressEditable = true
    
    @Published
    var isBottomSheetVisible = false
    
    @Published
    var autocompleteResults: [String] = []
    
    @Published
    var pins: [CLLocationCoordinate2D] = []
    
    @Published
    var selectedField: Field = .pickUp
    
    @Published
    var currentAddressCoordinate: CLLocationCoordinate2D?
    
    @Published
    var dropOffAddressCoordinate: CLLocationCoordinate2D?
    
    @Published
    var routesObject: RouteResponse?
    
    // MARK: - Private Properties
    private var debounceTimer: Timer?
    private let debounceDelay: TimeInterval = 0.5
    private var isAutoCompleteSelected = false
    private var lastAutocompleteQuery: String?
    private let locationManager = CLLocationManager()
    private var lastRegionUpdate: MKCoordinateRegion?
    
    private var userLocation: CLLocationCoordinate2D? {
        didSet {
            guard let location = userLocation else { return }
            updateRegion(to: location)
        }
    }
    
    private let services: HomeServicesProtocol
    private let analytics: AnalyticsCollectible
    
    // MARK: - Initializer
    init(coordinator: HomeCoordinator?, services: HomeServicesProtocol, analytics: AnalyticsCollectible) {
        self.services = services
        self.analytics = analytics
        super.init(coordinator: coordinator)
        
        analytics.collect(event: PRAnalyticsEvents.homeScreen)
        configureLocationManager()
    }
    
    // MARK: - Public Methods
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
        autocompleteResults = []
        
        guard isButtonEnabled, !isLoading else { return }
        
        guard !userId.trimmed.isEmpty, !currentAddress.trimmed.isEmpty, !dropOffAddress.trimmed.isEmpty else {
            return
        }
        
        isLoading = true
        
        analytics.collect(event: PRAnalyticsEvents.searchRide(userId: userId))
        
        coordinator?.autoCancellingTask { @MainActor in
            defer { self.isLoading = false }
            
            do {
                let response = try await self.services.estimateRide(
                    id: self.userId,
                    origin: self.currentAddress,
                    destination: self.dropOffAddress
                )
                
                self.routesObject = response
                
                let origin = response.origin
                let destination = response.destination
                
                if !origin.latitude.isZero,
                   !origin.longitude.isZero,
                   !destination.latitude.isZero,
                   !destination.longitude.isZero {
                    self.currentAddressCoordinate = CLLocationCoordinate2D(
                        latitude: origin.latitude, longitude: origin.longitude
                    )
                    
                    self.dropOffAddressCoordinate = CLLocationCoordinate2D(
                        latitude: destination.latitude, longitude: destination.longitude
                    )
                    
                    self.updatePins()
                    self.updateRegionForSelectedAddresses()
                }
                
                if let encodedPolyline = response.routeResponse?.routes.first?.polyline.encodedPolyline {
                    self.decodeAndSetPolyline(encodedPolyline)
                }
                                
                self.isAddressEditable = false
                self.isBottomSheetVisible = true
            } catch {
                self.handleNetworkError(error)
            }
        }
    }
    
    func locateUser() {
        guard let userLocation else { return }
        
        analytics.collect(event: PRAnalyticsEvents.locateUser)
        
        isAutoCompleteSelected = true
        
        updateRegion(to: userLocation)
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self else { return }
            if let error {
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
                    self.currentAddressCoordinate = location.coordinate
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isAutoCompleteSelected = false
                    self.validateForm()
                }
            }
        }
    }
    
    func calculateRoute() {
        guard let current = currentAddressCoordinate, let dropOff = dropOffAddressCoordinate else { return }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: current))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: dropOff))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let self else { return }
            if error != nil {
                return
            }
            
            guard let route = response?.routes.first else { return }
            
            DispatchQueue.main.async {
                self.polyline = route.polyline
                self.updateRegionToFitRoute(route.polyline)
            }
        }
    }
    
    func selectAutocompleteResult(_ result: String, and field: Field) {
        isAutoCompleteSelected = true
        
        switch field {
        case .pickUp:
            currentAddress = result
            geocodeAddress(result) { [weak self] coordinate in
                self?.currentAddressCoordinate = coordinate
                self?.updateRegionForSelectedAddresses()
            }
        case .dropOff:
            dropOffAddress = result
            geocodeAddress(result) { [weak self] coordinate in
                self?.dropOffAddressCoordinate = coordinate
                self?.updateRegionForSelectedAddresses()
            }
        }
        
        lastAutocompleteQuery = result
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isAutoCompleteSelected = false
            self.validateForm()
        }
    }
    
    func addressIsNotEditible() {
        showAlert(message: "You need to complete or cancel the current trip first.".localized, type: .warning, position: .top)
    }
    
    func cancelTrip() {
        analytics.collect(event: PRAnalyticsEvents.cancelRide(userId: userId))
        
        withAnimation {
            isBottomSheetVisible = false
            isAddressEditable = true
            routesObject = nil
            polyline = nil
            pins = []
        }
    }
    
    func confirmTrip(with id: Int) {
        guard
            !isLoading,
            let routeReponse = routesObject,
            let driver = routeReponse.options.first(where: { $0.id == id })
        else { return }
        
        analytics.collect(event: PRAnalyticsEvents.confirmRide(userId: userId))
        
        let requestDriver = ConfirmRideRequest.Driver(id: driver.id, name: driver.name)
        
        let model = ConfirmRideRequest(
            customerId: userId,
            origin: currentAddress,
            destination: dropOffAddress,
            distance: routeReponse.distance / 1000,
            duration: String(routeReponse.duration),
            driver: requestDriver,
            value: driver.value
        )
        
        isLoading = true
        
        coordinator?.autoCancellingTask { @MainActor in
            defer { self.isLoading = false }
            
            do {
                let _ = try await self.services.confirmRide(model: model)
                
                self.isBottomSheetVisible = false
                self.isAddressEditable = true
                self.coordinator?.navigate(to: .tripsHistory)
            } catch {
                self.handleNetworkError(error, alertPosition: .top)
            }
        }
    }
    
    func navigateToTripsHistory() {
        analytics.collect(event: PRAnalyticsEvents.homeScreenTime(duration: screenTime))
        
        analytics.collect(event: PRAnalyticsEvents.navigateToTripHistory)
        
        coordinator?.navigate(to: .tripsHistory)
    }
    
    func validateForm() {
        isButtonEnabled = !userId.trimmed.isEmpty &&
        !currentAddress.trimmed.isEmpty &&
        !dropOffAddress.trimmed.isEmpty
        
        if isButtonEnabled {
            autocompleteResults = []
        }
    }
}

// MARK: - Private Extension
private extension HomeViewModel {
    func checkAndTriggerAutocomplete(for query: String, field: Field) {
        validateForm()
        
        guard !isAutoCompleteSelected, !query.trimmed.isEmpty else { return }
        
        updatePins()
        
        if query == lastAutocompleteQuery {
            return
        }
        
        lastAutocompleteQuery = query
        triggerAutocomplete(for: query, field: field)
    }
    
    func triggerAutocomplete(for query: String, field: Field) {
        debounceTimer?.invalidate()
        selectedField = field
        
        guard !query.trimmed.isEmpty else {
            autocompleteResults = []
            return
        }
        
        debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceDelay, repeats: false) { [weak self] _ in
            self?.performAutocomplete(for: query, field: field)
        }
    }
    
    func performAutocomplete(for query: String, field: Field) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .address
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self else { return }
            if let error {
                return
            }
            
            self.autocompleteResults = response?.mapItems.compactMap { $0.placemark.title } ?? []
        }
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func updateRegion(to location: CLLocationCoordinate2D) {
        withAnimation {
            self.region = MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
    }
    
    func geocodeAddress(_ address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                completion(nil)
                return
            }
            
            let coordinate = placemarks?.first?.location?.coordinate
            completion(coordinate)
        }
    }
    
    func decodeAndSetPolyline(_ encodedPolyline: String) {
        var coordinates: [CLLocationCoordinate2D] = []
        var index = encodedPolyline.startIndex
        var lat: Int32 = 0
        var lng: Int32 = 0

        while index < encodedPolyline.endIndex {
            var b: Int32 = 0
            var shift: Int32 = 0
            var result: Int32 = 0
            repeat {
                b = Int32(encodedPolyline[index].asciiValue! - 63)
                result |= (b & 0x1F) << shift
                shift += 5
                index = encodedPolyline.index(after: index)
            } while b >= 0x20
            let dLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1))
            lat += dLat

            shift = 0
            result = 0
            repeat {
                b = Int32(encodedPolyline[index].asciiValue! - 63)
                result |= (b & 0x1F) << shift
                shift += 5
                index = encodedPolyline.index(after: index)
            } while b >= 0x20
            let dLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1))
            lng += dLng

            let coordinate = CLLocationCoordinate2D(latitude: Double(lat) / 1e5, longitude: Double(lng) / 1e5)
            coordinates.append(coordinate)
        }

        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        
        DispatchQueue.main.async {
            self.polyline = polyline
        }
    }
    
    func updateRegionForSelectedAddresses() {
        if let polyline {
            updateRegionToFitRoute(polyline)
        } else if let current = currentAddressCoordinate, let dropOff = dropOffAddressCoordinate {
            let center = CLLocationCoordinate2D(
                latitude: (current.latitude + dropOff.latitude) / 2,
                longitude: (current.longitude + dropOff.longitude) / 2
            )
            
            let span = MKCoordinateSpan(
                latitudeDelta: abs(current.latitude - dropOff.latitude) * 2,
                longitudeDelta: abs(current.longitude - dropOff.longitude) * 2
            )
            
            updateRegion(to: center, span: span)
        } else if let current = currentAddressCoordinate {
            updateRegion(to: current)
        } else if let dropOff = dropOffAddressCoordinate {
            updateRegion(to: dropOff)
        }
    }

    func updateRegion(to center: CLLocationCoordinate2D, span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)) {
        let newRegion = MKCoordinateRegion(center: center, span: span)
        
        // Verifica se a nova região é diferente da última atualizada
        if newRegion != lastRegionUpdate {
            withAnimation {
                self.region = newRegion
            }
            lastRegionUpdate = newRegion
        }
    }
    
    func updateRegionToFitRoute(_ polyline: MKPolyline) {
        let routeRect = polyline.boundingMapRect
        
        withAnimation {
            self.region = MKCoordinateRegion(routeRect)
        }
    }
    
    private func updatePins() {
        if let current = currentAddressCoordinate, let dropOff = dropOffAddressCoordinate {
            pins = [current, dropOff]
        } else {
            pins = []
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension HomeViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }
}
