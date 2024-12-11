//
//  String+Extensions.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import SwiftUI

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
