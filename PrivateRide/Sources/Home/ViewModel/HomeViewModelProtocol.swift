//
//  HomeViewModelProtocol.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import Foundation
import MapKit

protocol HomeViewModelProtocol: BaseViewModelProtocol {
    var region: MKCoordinateRegion { get set }
    var userId: String { get set }
    var currentAddress: String { get set }
    var dropOffAddress: String { get set }
    var polyline: MKPolyline? { get set }
    var autocompleteResults: [String] { get set }
    var isSwapping: Bool { get set }
    var isButtonEnabled: Bool { get set }
    var isAddressEditable: Bool { get set }
    var selectedField: HomeViewModel.Field { get set }
    var currentAddressCoordinate: CLLocationCoordinate2D? { get set }
    var dropOffAddressCoordinate: CLLocationCoordinate2D? { get set }
    
    func swapAddresses()
    func searchRide()
    func locateUser()
    func addressIsNotEditible()
    func selectAutocompleteResult(_ result: String, and field: HomeViewModel.Field)
}
