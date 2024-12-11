//
//  PRFloatingAlertType.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 10/12/24.
//

import SwiftUI

enum PRFloatingAlertType {
    case success
    case warning
    case error

    var backgroundColor: Color {
        switch self {
        case .success:
            return Color.green
        case .warning:
            return Color.orange
        case .error:
            return Color.red
        }
    }

    var icon: Image {
        switch self {
        case .success:
            return Image(systemName: "checkmark.circle")
        case .warning:
            return Image(systemName: "exclamationmark.triangle")
        case .error:
            return Image(systemName: "xmark.circle")
        }
    }
}
