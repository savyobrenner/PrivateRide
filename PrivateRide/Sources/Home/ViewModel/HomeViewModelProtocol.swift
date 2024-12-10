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
    func load()
}
