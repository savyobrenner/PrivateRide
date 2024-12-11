//
//  PRFloatingAlertModel.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 10/12/24.
//

struct PRFloatingAlertModel: Equatable {
    var type: PRFloatingAlertType
    var title: String
    var duration: Double = 4
    var position: PRAlertPosition = .top
}

extension PRFloatingAlertModel {
    enum PRAlertPosition {
        case top
        case bottom
    }
}
