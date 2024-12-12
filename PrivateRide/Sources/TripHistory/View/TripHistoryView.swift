//
//  TripHistoryView.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

import SwiftUI

struct TripHistoryView<ViewModel: TripHistoryViewModelProtocol>: View {
    @ObservedObject
    private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.Brand.lightGray.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        viewModel.dismiss(animated: true)
                    } label: {
                        Image(systemName: "arrow.left.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color.Brand.black)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
            
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Spacer()
                    
                    Text("Trips History")
                        .font(.brand(.regular, size: 20))
                        .foregroundStyle(Color.Brand.black)
                    
                    Spacer()
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
//                        ForEach(model.drivers, id: \.id) { driver in
//                            PRRideOptionCard(
//                                name: driver.name,
//                                price: driver.value,
//                                description: driver.description,
//                                vehicle: driver.vehicle,
//                                rating: driver.rating,
//                                comment: driver.comment,
//                                isSelected: selectedDriverID == driver.id
//                            )
//                            .onTapGesture {
//                                if selectedDriverID == driver.id {
//                                    selectedDriverID = nil
//                                } else {
//                                    selectedDriverID = driver.id
//                                }
//                            }
//                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                Spacer()
            }
        }
        .onAppear { }
    }
}

#if DEBUG
import Factory

#Preview {
TripHistoryView(viewModel: TripHistoryViewModel(
    coordinator: TripHistoryCoordinator(navigationController: .init()), services: Container.shared.tripHistoryServices()
    ))
}
#endif

