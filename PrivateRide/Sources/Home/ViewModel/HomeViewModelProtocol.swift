//
//  HomeViewModelProtocol.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import Foundation
import MapKit

protocol HomeViewModelProtocol: BaseViewModelProtocol {
    var region: MKCoordinateRegion { get }
    var currentAddress: String { get set }
    var dropOffAddress: String { get set }
    var isSwapping: Bool { get set }
    
    func swapAddresses()
}
