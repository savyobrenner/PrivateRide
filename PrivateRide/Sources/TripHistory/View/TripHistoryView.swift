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
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    
                    Text("Trips History")
                        .font(.brand(.regular, size: 20))
                        .foregroundStyle(Color.Brand.black)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    PRTextField(
                        icon: .personCircleIcon,
                        placeholder: "User ID",
                        text: $viewModel.userId,
                        iconSize: 30,
                        placeHolderSize: 12,
                        textFieldSize: 14
                    )
                    
                    Divider()
                        .padding(.leading, 40)
                    
                    Text("Filter by Driver")
                        .font(.brand(.regular, size: 14))
                        .foregroundStyle(Color.Brand.black)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.drivers, id: \.id) { driver in
                                Text(driver.name)
                                    .padding()
                                    .font(.brand(.regular, size: 10))
                                    .foregroundStyle(Color.Brand.white)
                                    .frame(width: 120, height: 30)
                                    .background {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(
                                                viewModel.selectedDriverID == driver.id
                                                ? Color.Brand.primary
                                                : Color.Brand.gray
                                            )
                                    }
                                    .onTapGesture {
                                        if viewModel.selectedDriverID == driver.id {
                                            viewModel.selectedDriverID = nil
                                        } else {
                                            viewModel.selectedDriverID = driver.id
                                        }
                                    }
                            }
                        }
                    }
                    
                    PRButton(
                        title: "Search",
                        style: .defaultStyle,
                        isLoading: viewModel.isLoading,
                        isEnabled: viewModel.isButtonEnabled
                    ) {
                        viewModel.searchTrips()
                    }
                    .padding(.top, 10)
                }
                .padding(.top, 40)
                .padding(.horizontal, 16)
                
                if viewModel.trips.isEmpty {
                    HStack {
                        Spacer()
                        
                        VStack {
                            Text("No trips matchs the criteria :(")
                                .font(.brand(.semibold, size: 14))
                                .foregroundStyle(Color.Brand.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                            
                            Text("Please adjust the criteria and try again!")
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
                }
                
                Spacer()
            }
        }
        .onAppear { }
    }
}

//#if DEBUG
//import Factory
//
//#Preview {
//TripHistoryView(viewModel: TripHistoryViewModel(
//    coordinator: TripHistoryCoordinator(navigationController: .init()), services: Container.shared.tripHistoryServices()
//    ))
//}
//#endif
//
