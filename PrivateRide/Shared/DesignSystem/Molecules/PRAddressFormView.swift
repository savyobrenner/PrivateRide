//
//  PRAddressFormView.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 10/12/24.
//

import SwiftUI

struct PRAddressFormView: View {
    enum Action {
        case swapAddresses
        case searchRide
        case addressIsNotEditible
    }
    
    @Binding
    var identification: String
    
    @Binding
    var currentAddress: String
    
    @Binding
    var dropOffAddress: String
    
    @Binding
    var isSwapping: Bool

    @Binding
    var isLoading: Bool

    @Binding
    var isButtonEnabled: Bool
    
    @Binding
    var isEditable: Bool

    @State
    private var isIdentificationExpanded = true
    
    @State
    private var isWhereToExpanded = true
    
    let action: ((Action) -> Void)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PRFormSectionHeader(title: "Identification".localized, isExpanded: $isIdentificationExpanded)
            
            if isIdentificationExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    PRTextField(
                        icon: .personCircleIcon,
                        placeholder: "ID Number".localized,
                        text: $identification
                    )
                }
            }
            
            PRFormSectionHeader(title: "whereTo".localized, isExpanded: $isWhereToExpanded)
            
            if isWhereToExpanded {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        PRTextField(
                            icon: .circlePinIcon,
                            placeholder: "Pick Up".localized,
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
                            placeholder: "Drop Off".localized,
                            text: $dropOffAddress
                        )
                        .opacity(isSwapping ? 0.5 : 1)
                        .offset(y: isSwapping ? -10 : 0)
                        .animation(.easeInOut(duration: 0.3), value: isSwapping)
                    }
                    
                    Button {
                        action(.swapAddresses)
                    } label: {
                        Image(.changeAddressIcon)
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
            }
            
            PRButton(
                title: "Search".localized,
                style: .defaultStyle,
                isLoading: isLoading && isEditable,
                isEnabled: isButtonEnabled
            ) {
                withAnimation {
                    isIdentificationExpanded = false
                    isWhereToExpanded = false
                }
                
                action(.searchRide)
            }
            .padding(.top, 8)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Brand.white)
                .shadow(color: Color.Brand.gray.opacity(0.2), radius: 5, x: 0, y: 2)
        )
        .overlay {
            if !isEditable {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.Brand.black.opacity(0.4))
                    .onTapGesture {
                        action(.addressIsNotEditible)
                    }
            }
        }
    }
}

#Preview {
    PRAddressFormView(
        identification: .constant("123dd"),
        currentAddress: .constant("Rua Palmira Ramos Teles 1600"),
        dropOffAddress: .constant("Shopping Jardins"),
        isSwapping: .constant(false),
        isLoading: .constant(true),
        isButtonEnabled: .constant(true),
        isEditable: .constant(false)
    ) {_ in }
    .padding()
}
