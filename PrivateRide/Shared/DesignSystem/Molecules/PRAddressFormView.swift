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
    }
    
    enum Field {
        case pickUp
        case dropOff
    }
    
    @Binding
    var identification: String
    
    @Binding
    var currentAddress: String
    
    @Binding
    var dropOffAddress: String
    
    @Binding
    var autocompleteResults: [String]
    
    @Binding
    var isSwapping: Bool

    @Binding
    var isLoading: Bool

    @Binding
    var isButtonEnabled: Bool

    @State
    private var isIdentificationExpanded = true
    
    @State
    private var isWhereToExpanded = true

    @State
    private var activeField: Field?
    
    let action: ((Action) -> Void)

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
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        PRTextField(
                            icon: .circlePinIcon,
                            placeholder: "Pick Up",
                            text: $currentAddress
                        )
                        .onTapGesture {
                            activeField = .pickUp
                        }
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
                        .onTapGesture {
                            activeField = .dropOff
                        }
                        .opacity(isSwapping ? 0.5 : 1)
                        .offset(y: isSwapping ? -10 : 0)
                        .animation(.easeInOut(duration: 0.3), value: isSwapping)
                        
                        if !autocompleteResults.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(autocompleteResults, id: \.self) { result in
                                        Text(result)
                                            .font(.caption)
                                            .padding(8)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(6)
                                            .onTapGesture {
                                                if activeField == .pickUp {
                                                    currentAddress = result
                                                } else if activeField == .dropOff {
                                                    dropOffAddress = result
                                                }
                                                autocompleteResults = []
                                            }
                                    }
                                }
                                .padding(.top, 8)
                            }
                        }
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
            
            PRButton(title: "Search", style: .defaultStyle, isLoading: isLoading, isEnabled: isButtonEnabled) {
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
    }
}

#Preview {
    PRAddressFormView(
        identification: .constant("123dd"),
        currentAddress: .constant("Rua Palmira Ramos Teles 1600"),
        dropOffAddress: .constant("Shopping Jardins"),
        autocompleteResults: .constant([]),
        isSwapping: .constant(false),
        isLoading: .constant(true),
        isButtonEnabled: .constant(true)
    ) {_ in }
    .padding()
}
