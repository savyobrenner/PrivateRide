//
//  PRTextField.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 10/12/24.
//

import SwiftUI

struct PRTextField: View {
    let icon: ImageResource
    let placeholder: String
    
    @Binding
    var text: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(icon)
                .resizable()
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                if !text.isEmpty {
                    Text(placeholder)
                        .font(.brand(.regular, size: 12))
                        .foregroundStyle(Color.Brand.gray)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                TextField(placeholder, text: $text)
                    .font(.brand(.semibold, size: 14))
                    .foregroundStyle(Color.Brand.black)
            }
            .animation(.easeInOut(duration: 0.2), value: text)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PRTextField(icon: .circlePinIcon, placeholder: "Current Address", text: .constant("Rua Palmira Ramos Teles 1600"))
        
        PRTextField(icon: .flagCircleIcon, placeholder: "Drop Off", text: .constant("Shopping Jardins"))
    }
    .padding(.horizontal, 16)
}
