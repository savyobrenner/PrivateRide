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
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    
                    Text("Trips History")
                        .font(.brand(.black, size: 20))
                        .foregroundStyle(Color.Brand.black)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                
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
        coordinator: TripHistoryCoordinator(navigationController: .init())
    ))
}
#endif

