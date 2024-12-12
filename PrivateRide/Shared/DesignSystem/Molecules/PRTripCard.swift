//
//  PRTripCard.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

import SwiftUI

extension PRTripCard {
    struct Model: Identifiable {
        let id = UUID()
        let date: String
        let origin: String
        let destination: String
        let driverName: String
        let value: String
        let distance: String
    }
}

struct PRTripCard: View {
    let model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(model.date)
                    .font(.brand(.semibold, size: 12))
                    .foregroundStyle(Color.Brand.black)
                
                Spacer()
                
                Text(model.distance)
                    .font(.brand(.semibold, size: 12))
                    .foregroundStyle(Color.Brand.gray)
            }
            
            Rectangle()
                .fill(Color.Brand.lightGray)
                .frame(maxWidth: .infinity)
                .frame(height: 1)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(.circlePinIcon)
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Text(model.origin)
                        .font(.brand(.regular, size: 14))
                        .foregroundStyle(Color.Brand.black)
                }
                
                Rectangle()
                    .fill(Color.Brand.lightGray)
                    .frame(width: 1, height: 30)
                    .padding(.leading, 12)

                HStack {
                    Image(.flagCircleIcon)
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Text(model.destination)
                        .font(.brand(.regular, size: 14))
                        .foregroundStyle(Color.Brand.black)
                }
            }
            
            Rectangle()
                .fill(Color.Brand.lightGray)
                .frame(maxWidth: .infinity)
                .frame(height: 1)
            
            HStack(alignment: .top) {
                Text(model.driverName)
                    .font(.brand(.semibold, size: 16))
                    .foregroundStyle(Color.Brand.black)
                
                Spacer()
                
                Text(model.value)
                    .font(.brand(.semibold, size: 20))
                    .foregroundStyle(Color.Brand.primary)
            }
        }
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity)
        .frame(height: 230)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Brand.white)
                .shadow(color: Color.Brand.gray.opacity(0.2), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    ZStack {
        Color.Brand.black
        
        PRTripCard(model: .init (
            date: "Dec 12 2024",
            origin: "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200",
            destination: "Av. Thomas Edison, 365 - Barra Funda, São Paulo - SP, 01140-000",
            driverName: "Homer Simpson",
            value: "R$ 20,00",
            distance: "10 kilometros | 20 minutes"
        ))
    }
}
