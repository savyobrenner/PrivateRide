//
//  PRFloatingAlertModifier.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 10/12/24.
//

import SwiftUI

struct PRFloatingAlertModifier: ViewModifier {
    @Binding var alert: PRFloatingAlertModel?
    @State private var workItem: DispatchWorkItem?

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainAlertView()
                }
                .animation(.spring(), value: alert)
            )
            .onChange(of: alert) { _ in
                showAlert()
            }
    }

    @ViewBuilder private func mainAlertView() -> some View {
        if let alert = alert {
            VStack {
                if alert.position == .top {
                    PRFloatingAlertView(alert: alert)
                    Spacer()
                } else {
                    Spacer()
                    PRFloatingAlertView(alert: alert)
                        .padding(.bottom, 80)
                }
            }
            .transition(.move(edge: alert.position == .top ? .top : .bottom))
        }
    }

    private func showAlert() {
        guard let alert = alert else { return }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        if alert.duration > 0 {
            workItem?.cancel()

            let task = DispatchWorkItem {
                dismissAlert()
            }

            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + alert.duration, execute: task)
        }
    }

    private func dismissAlert() {
        withAnimation {
            alert = nil
        }

        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func showLAPAlert(alert: Binding<PRFloatingAlertModel?>) -> some View {
        self.modifier(PRFloatingAlertModifier(alert: alert))
    }
}
