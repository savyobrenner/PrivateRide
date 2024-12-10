//
//  PRTextField.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 10/12/24.
//

import SwiftUI

struct PRTextField: View {
    let icon: ImageResource
    let title: String
    let placeholder: String
    
    @Binding
    var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)

            HStack {
                Image(icon)
                    .foregroundColor(.green)
                    .frame(width: 24, height: 24)
                
                TextField(placeholder, text: $text)
                    .font(.body)
                    .foregroundColor(.black)
            }
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
            .shadow(radius: 2)
        }
    }
}

#Preview {
    PRTextField(icon: .logo, title: "Current Address", placeholder: "Address", text: .constant(""))
}
