//
//  HomeViewModel.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import MapKit
import SwiftUI

class HomeViewModel: BaseViewModel<HomeCoordinator>, HomeViewModelProtocol {
    @Published
    var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
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
    var isUserIdValid: Bool {
        !userId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isCurrentAddressValid: Bool {
        !currentAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isDropOffAddressValid: Bool {
        !dropOffAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    override init(coordinator: HomeCoordinator?) {
        super.init(coordinator: coordinator)
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
    
    private func validateForm() {
        isButtonEnabled = isUserIdValid && isCurrentAddressValid && isDropOffAddressValid
    }
}
