//
//  PRAddressFormView.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 10/12/24.
//

import SwiftUI

struct PRAddressFormView: View {
    @Binding
    var identification: String
    
    @Binding
    var currentAddress: String
    
    @Binding
    var dropOffAddress: String
    
    @Binding
    var isSwapping: Bool

    @State
    private var isIdentificationExpanded = true
    
    @State
    private var isWhereToExpanded = true

    let action: (() -> Void)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PRFormSectionHeader(title: "Identification", isExpanded: $isIdentificationExpanded)
            
            if isIdentificationExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    PRTextField(
                        icon: .personCircleIcon,
                        placeholder: "ID Number",
                        text: $identification
                    )
                }
            }

            PRFormSectionHeader(title: "Where To?", isExpanded: $isWhereToExpanded)
            
            if isWhereToExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    PRTextField(
                        icon: .circlePinIcon,
                        placeholder: "Pick Up",
                        text: $currentAddress
                    )
                    .opacity(isSwapping ? 0.5 : 1)
                    .offset(y: isSwapping ? +10 : 0)
                    .animation(.easeInOut(duration: 0.3), value: isSwapping)
                    
                    Rectangle()
                        .foregroundStyle(Color.Brand.lightGray)
                        .frame(width: 1, height: 40)
                        .padding(.leading, 12)
                    
                    PRTextField(
                        icon: .flagCircleIcon,
                        placeholder: "Drop Off",
                        text: $dropOffAddress
                    )
                    .opacity(isSwapping ? 0.5 : 1)
                    .offset(y: isSwapping ? -10 : 0)
                    .animation(.easeInOut(duration: 0.3), value: isSwapping)
                }
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
        identification: .constant("123dd"),
        currentAddress: .constant("Rua Palmira Ramos Teles 1600"),
        dropOffAddress: .constant("Shopping Jardins"),
        isSwapping: .constant(false)
    ) {}
    .padding()
}
