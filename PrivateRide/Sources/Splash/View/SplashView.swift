//
//  SplashView.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import SwiftUI

struct SplashView<ViewModel: SplashViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.Brand.white
            
            Image(.logoWithTitle)
                .resizable()
                .frame(width: 200, height: 200)
        }
        .onAppear { viewModel.load() }
    }
}

#if DEBUG
import Factory

#Preview {
    SplashView(viewModel: SplashViewModel(
        coordinator: SplashCoordinator(navigationController: .init()),
        serviceLocator: Container.shared.serviceLocator()
    ))
}
#endif

