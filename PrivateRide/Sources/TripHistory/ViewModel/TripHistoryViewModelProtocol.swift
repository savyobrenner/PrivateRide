//
//  TripHistoryViewModelProtocol.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

import Foundation

protocol TripHistoryViewModelProtocol: BaseViewModelProtocol {
    var userId: String { get set }
    var selectedDriverID: Int? { get set }
    var drivers: [ConfirmRideRequest.Driver] { get }
    var trips: [String] { get set }
    var isButtonEnabled: Bool { get set }
    
    func searchTrips()
}
