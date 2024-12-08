//
//  RunOnceViewModifier.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import SwiftUI

private struct RunOnceViewModifier: ViewModifier {
    
    @State
    private var hasRun = false
    
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasRun else { return }
                action()
                hasRun = true
            }
    }
}

extension View {
    func runOnceOnAppear(action: @escaping () -> Void) -> some View {
        modifier(RunOnceViewModifier(action: action))
    }
}

