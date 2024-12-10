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
    var currentAddress: String
    
    @Published
    var dropOffAddress: String
    
    @Published
    var isSwapping = false
    
    override init(coordinator: HomeCoordinator?) {
        self.currentAddress = "457 Castle Street, New York"
        self.dropOffAddress = "Universal Airport, New York"
        
        super.init(coordinator: coordinator)
    }
    
    func swapAddresses() {
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
}
