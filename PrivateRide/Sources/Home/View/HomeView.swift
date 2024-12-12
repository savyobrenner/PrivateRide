//
//  HomeView.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import MapKit
import SwiftUI

struct HomeView<ViewModel: HomeViewModelProtocol>: View {
    @ObservedObject
    private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            PRMapView(
                region: $viewModel.region,
                pins: viewModel.pins,
                polyline: viewModel.polyline
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                PRAddressFormView(
                    identification: $viewModel.userId,
                    currentAddress: $viewModel.currentAddress,
                    dropOffAddress: $viewModel.dropOffAddress,
                    isSwapping: $viewModel.isSwapping,
                    isLoading: $viewModel.isLoading,
                    isButtonEnabled: $viewModel.isButtonEnabled,
                    isEditable: $viewModel.isAddressEditable
                ) { action in
                    switch action {
                    case .swapAddresses:
                        viewModel.swapAddresses()
                    case .searchRide:
                        viewModel.searchRide()
                    case .addressIsNotEditible:
                        viewModel.addressIsNotEditible()
                    }
                }
                
                if !viewModel.autocompleteResults.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Suggestions")
                            .font(.brand(.semibold, size: 14))
                            .foregroundColor(Color.Brand.black.opacity(0.8))
                            .padding(.horizontal, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(viewModel.autocompleteResults, id: \.self) { result in
                                    Text(result)
                                        .font(.brand(.regular, size: 12))
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.Brand.gray.opacity(0.2))
                                        )
                                        .onTapGesture {
                                            viewModel.selectAutocompleteResult(result, and: viewModel.selectedField)
                                            viewModel.autocompleteResults = []
                                        }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.Brand.white.opacity(0.9))
                            .shadow(color: Color.Brand.gray.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            if viewModel.isAddressEditable {
                VStack(alignment: .trailing, spacing: 10) {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            viewModel.navigateToTripsHistory()
                        } label: {
                            Image(systemName: "car.2.fill")
                                .foregroundStyle(Color.Brand.primary)
                                .frame(width: 24, height: 24)
                                .padding()
                                .background {
                                    Circle()
                                        .fill(Color.Brand.white)
                                        .shadow(radius: 3)
                                }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            viewModel.locateUser()
                        } label: {
                            Image(systemName: "location.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color.Brand.primary)
                                .padding()
                                .background {
                                    Circle()
                                        .fill(Color.Brand.white)
                                        .shadow(radius: 3)
                                }
                        }
                    }
                }
                .padding([.bottom, .horizontal])
            }
            
            if viewModel.isBottomSheetVisible, let routesObject = viewModel.routesObject {
                VStack {
                    Spacer()
                    
                    PRBottomSheet(
                        isLoading: $viewModel.isLoading,
                        model: .fromResponse(routesObject)
                    ) { action in
                        switch action {
                        case .cancel:
                            viewModel.cancelTrip()
                        case let .confirm(driverId):
                            viewModel.confirmTrip(with: driverId)
                        }
                    }
                }
                .transition(.move(edge: .bottom))
                .ignoresSafeArea()
            }
        }
        .showPRAlert(alert: $viewModel.currentAlert)
    }
}

#if DEBUG
import Factory

#Preview {
    HomeView(viewModel: HomeViewModel(
        coordinator: HomeCoordinator(navigationController: .init()),
        services: Container.shared.homeServices(),
        analytics: Container.shared.analyticsCollector()
    ))
}
#endif

