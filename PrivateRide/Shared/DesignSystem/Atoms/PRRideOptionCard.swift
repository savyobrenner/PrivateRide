//
//  PRRideOptionCard.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 11/12/24.
//

import SwiftUI

struct PRRideOptionCard: View {
    let name: String
    let price: Double
    let description: String
    let vehicle: String
    let rating: Double?
    let comment: String?
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(name)
                    .font(.brand(.bold, size: 16))
                    .foregroundStyle(Color.Brand.black)
                
                if let rating {
                    HStack(spacing: 2) {
                        ForEach(0..<5) { star in
                            Image(systemName: star < Int(rating) ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(Color.yellow)
                        }
                    }
                }
            }
            
            Text("R$\(String(format: "%.2f", price))")
                .font(.brand(.bold, size: 16))
                .foregroundStyle(Color.Brand.primary)
            
            
            Text(vehicle)
                .font(.brand(.regular, size: 14))
                .foregroundStyle(Color.Brand.gray)
            
            if let comment, !comment.isEmpty {
                Text("“\(comment)”")
                    .font(.footnote)
                    .italic()
                    .foregroundStyle(Color.Brand.gray)
                    .padding(.top, 4)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 40, height: 160)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.Brand.primary : Color.Brand.lightGray, lineWidth: 1)
        )
    }
}
