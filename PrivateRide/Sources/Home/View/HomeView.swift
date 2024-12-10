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

