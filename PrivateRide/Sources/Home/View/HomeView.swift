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
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                .ignoresSafeArea()

            VStack {
                PRAddressFormView(
                    identification: $viewModel.userId,
                    currentAddress: $viewModel.currentAddress,
                    dropOffAddress: $viewModel.dropOffAddress,
                    autocompleteResults: $viewModel.autocompleteResults,
                    isSwapping: $viewModel.isSwapping,
                    isLoading: $viewModel.isLoading,
                    isButtonEnabled: $viewModel.isButtonEnabled
                ) { action in
                    switch action {
                    case .swapAddresses:
                        viewModel.swapAddresses()
                    case .searchRide:
                        viewModel.searchRide()
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }

            VStack {
                Spacer()
                
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
                            .background(
                                Circle()
                                    .fill(Color.Brand.white)
                                    .shadow(radius: 3)
                            )
                    }
                    .padding()
                }
            }
        }
        .onAppear { }
    }
}

#if DEBUG
import Factory

#Preview {
HomeView(viewModel: HomeViewModel(
        coordinator: HomeCoordinator(navigationController: .init())
    ))
}
#endif

