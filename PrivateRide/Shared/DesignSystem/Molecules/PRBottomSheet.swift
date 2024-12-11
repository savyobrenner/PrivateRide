//
//  PRBottomSheet.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 11/12/24.
//

import SwiftUI

extension PRBottomSheet {
    struct Model {
        let title: String
        let description: String
        let warning: String?
        let drivers: [Driver]
        
        static func fromResponse(_ response: RouteResponse) -> Self {
            
            guard let route = response.routeResponse?.routes.first else {
                return .init(title: "", description: "", warning: "", drivers: [])
            }
            
            let description = "\(route.localizedValues.distance) | \(route.localizedValues.duration)"
            
            var warnings: String?
            if !route.warnings.isEmpty {
                warnings = route.warnings.joined(separator: "\n")
            }
            
            let drivers: [Driver] = response.options.compactMap { option in
                return .init(
                    id: option.id,
                    name: option.name,
                    description: option.description,
                    vehicle: option.vehicle,
                    rating: option.review?.rating,
                    comment: option.review?.comment,
                    value: option.value
                )
            }
            
            return .init(
                title: route.description,
                description: description,
                warning: warnings,
                drivers: drivers
            )
        }
    }
}

extension PRBottomSheet.Model {
    struct Driver {
        let id: Int
        let name: String
        let description: String
        let vehicle: String
        let rating: Double?
        let comment: String?
        let value: Double
        
    }
}

struct PRBottomSheet: View {
    let model: Model
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                PRButton(title: "Cancel", style: .outline, isLoading: false, isEnabled: true) {
                    
                }
                
                PRButton(title: "Confirm", style: .defaultStyle, isLoading: false, isEnabled: true) {
                    
                }
            }
            .padding([.top, .horizontal], 16)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(model.title)
                    .font(.brand(.bold, size: 18))
                    .foregroundStyle(Color.Brand.black)
                
                Text(model.description)
                    .font(.brand(.regular, size: 14))
                    .foregroundStyle(Color.Brand.gray)
                    .padding(.top, 4)
                
                if let warning = model.warning {
                    Text(warning)
                        .padding()
                        .font(.brand(.regular, size: 12))
                        .foregroundStyle(Color.Brand.white)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.red)
                        }
                        .padding(.top, 20)
                }
                
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(1...5, id: \.self) { index in
                        RideOptionCard(
                            name: "Option \(index)",
                            price: Double(index * 5),
                            distance: "5km",
                            rating: Double(index % 5)
                        )
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 150)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: 400)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.Brand.white)
                .shadow(radius: 8)
        )
    }
}

struct RideOptionCard: View {
    let name: String
    let price: Double
    let distance: String
    let rating: Double
    
    var body: some View {
        VStack(spacing: 8) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 100, height: 60)
                .cornerRadius(8)
            
            Text(name)
                .font(.subheadline)
                .bold()
            
            HStack(spacing: 4) {
                Text("$\(String(format: "%.2f", price))")
                    .font(.headline)
                    .foregroundColor(.green)
                Text("/\(distance)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 2) {
                ForEach(0..<5) { star in
                    Image(systemName: star < Int(rating) ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding()
        .frame(width: 120, height: 150)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.green, lineWidth: 2)
        )
    }
}

#Preview {
    ZStack {
        Color.blue
            .overlay(
                Text("Map Placeholder")
                    .foregroundColor(.white)
                    .bold()
            )
        
        PRBottomSheet(
            model: .init(
                title: "Marginal Pinheiros",
                description: "3,5 KM | 20 minutos",
                warning: "Este trajeto inclui estradas restritas mediante a matrícula.",
                drivers: []
            )
        ) {
            
        }
    }
}
