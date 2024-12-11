//
//  PRFloatingAlertView.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 10/12/24.
//

import SwiftUI

struct PRFloatingAlertView: View {
    let alert: PRFloatingAlertModel
    
    var body: some View {
        HStack {
            alert.type.icon
                .foregroundStyle(Color.Brand.gray)
            
            Text(alert.title)
                .font(.brand(.semibold, size: 14))
                .foregroundStyle(Color.Brand.gray)
            
            Spacer()
        }
        .padding()
        .background(alert.type.backgroundColor)
        .cornerRadius(8)
        .shadow(color: Color.Brand.black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
}
