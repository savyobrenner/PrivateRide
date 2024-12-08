//
//  AppFont.swift
//  LikeAPPro
//
//  Created by Savyo Brenner on 26/05/24.
//  Copyright © 2024 LikeAPPro Tecnologia. All rights reserved.
//

import SwiftUI

extension Font {
    
    static func brand(_ name: BrandFontName = .regular, size: CGFloat = 16, relativeTo: TextStyle = .body) -> Font {
        .custom(name.rawValue, size: size, relativeTo: relativeTo)
    }
}

extension UIFont {
    
    static func brand(_ name: BrandFontName = .regular, size: CGFloat = 16, relativeTo: TextStyle = .body) -> UIFont {
        UIFont(name: name.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
}


