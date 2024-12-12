//
//  SplashView.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import SwiftUI

struct SplashView<ViewModel: SplashViewModelProtocol>: View {
    @ObservedObject
    private var viewModel: ViewModel
    
    @State
    private var scaleEffect: CGFloat = 0.5
    
    init(viewModel: ViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.Brand.white
            
            Image(.logoWithTitle)
                .resizable()
                .frame(width: 200, height: 200)
                .scaleEffect(scaleEffect)
                .animation(
                    Animation.spring(duration: 2),
                    value: scaleEffect
                )
        }
        .onAppear {
            scaleEffect = 1.0
            viewModel.load()
        }
    }
}

#if DEBUG
import Factory

#Preview {
    SplashView(viewModel: SplashViewModel(
        coordinator: SplashCoordinator(navigationController: .init()),
        analytics: Container.shared.analyticsCollector()
    ))
}
#endif

