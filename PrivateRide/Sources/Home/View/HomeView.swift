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
            Map(coordinateRegion: .constant(viewModel.region), showsUserLocation: true)
                .ignoresSafeArea()
            
            VStack {
                PRAddressFormView(
                    identification: .constant("123"),
                    currentAddress: $viewModel.currentAddress,
                    dropOffAddress: $viewModel.dropOffAddress,
                    isSwapping: $viewModel.isSwapping
                ) {
                    viewModel.swapAddresses()
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 100)
        }
        .ignoresSafeArea()
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

