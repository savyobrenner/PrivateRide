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
            
            let description = "\(route.localizedValues.distance.text) | \(route.localizedValues.duration.text)"
            
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
    enum Action {
        case cancel
        case confirm(Int)
    }
    
    @Binding
    var isLoading: Bool
    
    let model: Model
    let action: (Action) -> Void
    
    @State
    private var selectedDriverID: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                PRButton(title: "Cancel".localized, style: .outline, isLoading: false, isEnabled: !isLoading) {
                    action(.cancel)
                }
                
                PRButton(title: "Confirm".localized, style: .defaultStyle, isLoading: isLoading, isEnabled: selectedDriverID != nil) {
                    if let selectedDriverID {
                        action(.confirm(selectedDriverID))
                    }
                }
            }
            .padding([.horizontal], 16)
            
            if !model.title.isEmpty {
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
                .frame(maxWidth: .infinity)
            }
            
            if model.drivers.isEmpty {
                HStack {
                    Spacer()
                    
                    VStack {
                        Text("No drivers available in your area.")
                            .font(.brand(.semibold, size: 14))
                            .foregroundStyle(Color.Brand.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                        
                        Text("Please adjust your pickup or drop-off location to find available rides.")
                            .font(.brand(.regular, size: 12))
                            .foregroundStyle(Color.Brand.gray.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                    }
                    .padding(.vertical, 20)
                    
                    Spacer()
                }
            } else {
                Text("Please choose between one of our \(model.drivers.count) drivers")
                    .font(.brand(.regular, size: 12))
                    .foregroundStyle(Color.Brand.black)
                    .padding(.horizontal, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(model.drivers, id: \.id) { driver in
                            PRRideOptionCard(
                                name: driver.name,
                                price: driver.value,
                                description: driver.description,
                                vehicle: driver.vehicle,
                                rating: driver.rating,
                                comment: driver.comment,
                                isSelected: selectedDriverID == driver.id
                            )
                            .onTapGesture {
                                if selectedDriverID == driver.id {
                                    selectedDriverID = nil
                                } else {
                                    selectedDriverID = driver.id
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(height: 160)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: model.drivers.isEmpty ? 200 : 440)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.Brand.white)
                .shadow(radius: 8)
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
            isLoading: .constant(false),
            model: .init(
                title: "Marginal Pinheiros",
                description: "3,5 KM | 20 minutos",
                warning: "Este trajeto inclui estradas restritas mediante a matrícula.",
                drivers: [
                    .init(
                        id: 1,
                        name: "Homer Simpson",
                        description: "Olá! Sou o Homer, seu motorista camarada! Relaxe e aproveite o passeio, com direito a rosquinhas e boas risadas (e talvez alguns desvios).",
                        vehicle: "Plymouth Valiant 1973 rosa e enferrujado",
                        rating: 2,
                        comment: "Motorista simpático, mas errou o caminho 3 vezes. O carro cheira a donuts.",
                        value: 50.5
                    ),
                    .init(
                        id: 2,
                        name: "Homer Simpson",
                        description: "Olá! Sou o Homer, seu motorista camarada! Relaxe e aproveite o passeio, com direito a rosquinhas e boas risadas (e talvez alguns desvios).",
                        vehicle: "Plymouth Valiant 1973 rosa e enferrujado",
                        rating: 2,
                        comment: "Motorista simpático, mas errou o caminho 3 vezes. O carro cheira a donuts.",
                        value: 50.5
                    ),
                    .init(
                        id: 3,
                        name: "Homer Simpson",
                        description: "Olá! Sou o Homer, seu motorista camarada! Relaxe e aproveite o passeio, com direito a rosquinhas e boas risadas (e talvez alguns desvios).",
                        vehicle: "Plymouth Valiant 1973 rosa e enferrujado",
                        rating: 2,
                        comment: "Motorista simpático, mas errou o caminho 3 vezes. O carro cheira a donuts.",
                        value: 50.5
                    )
                ]
            )
        ) { _ in
            
        }
    }
}
