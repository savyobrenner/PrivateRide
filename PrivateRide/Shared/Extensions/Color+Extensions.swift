//
//  Color+Extensions.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import SwiftUI
import UIKit

extension Color {
    var uiColor: UIColor {
        let components = self.components
        return UIColor(red: components.red, green: components.green, blue: components.blue, alpha: components.alpha)
    }

    private var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        } else {
            // Default color components (black)
            r = 0
            g = 0
            b = 0
            a = 1
        }

        return (r, g, b, a)
    }
}
