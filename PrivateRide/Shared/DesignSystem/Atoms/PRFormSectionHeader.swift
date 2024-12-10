//
//  PRFormSectionHeader.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 11/12/24.
//

import SwiftUI

struct PRFormSectionHeader: View {
    let title: String
    
    @Binding
    var isExpanded: Bool
    
    var body: some View {
        Button {
            withAnimation {
                isExpanded.toggle()
            }
        } label: {
            HStack {
                Text(title)
                    .font(.brand(.semibold))
                    .foregroundStyle(Color.Brand.black)
                
                Spacer()
                
                Image(systemName: "chevron.up")
                    .frame(width: 16, height: 16)
                    .rotationEffect(.degrees(isExpanded ? 0 : 180))
                    .animation(.easeInOut(duration: 0.3), value: isExpanded)
                    .foregroundColor(Color.Brand.black)
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    PRFormSectionHeader(title: "Where to?", isExpanded: .constant(true))
}
