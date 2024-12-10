//
//  PRAddressFormView.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 10/12/24.
//

import SwiftUI

struct PRAddressFormView: View {
    @Binding
    var currentAddress: String
    
    @Binding
    var dropOffAddress: String
    
    let action: (() -> Void)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Where To?")
                    .font(.brand(.semibold))
                    .foregroundStyle(Color.Brand.black)
                
                Spacer()
                
                Button {
                    action()
                } label: {
                    Image(.changeAddressIcon)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            
            VStack(alignment: .leading, spacing: 0) {
                PRTextField(
                    icon: .circlePinIcon,
                    placeholder: "Pick Up",
                    text: $currentAddress
                )
                
                Rectangle()
                    .foregroundStyle(Color.Brand.lightGray)
                    .frame(width: 1, height: 40)
                    .padding(.leading, 12)
                
                PRTextField(
                    icon: .flagCircleIcon,
                    placeholder: "Drop Off",
                    text: $dropOffAddress
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Brand.white)
                .shadow(color: Color.Brand.gray.opacity(0.2), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    PRAddressFormView(
        currentAddress: .constant("Rua Palmira Ramos Teles 1600"),
        dropOffAddress: .constant("Shopping Jardins")
    ) {}
    .padding()
}
