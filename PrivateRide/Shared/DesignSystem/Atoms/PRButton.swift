//
//  PRButton.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 11/12/24.
//

import SwiftUI

struct PRButton: View {
    enum Style {
        case defaultStyle
        case outline
    }

    let title: String
    let style: Style
    let isLoading: Bool
    let isEnabled: Bool
    let action: () -> Void

    private var backgroundColor: Color {
        if !isEnabled {
            return Color.Brand.gray.opacity(0.5)
        }
        
        switch style {
        case .defaultStyle:
            return Color.Brand.primary
        case .outline:
            return Color.Brand.clear
        }
    }

    private var textColor: Color {
        if !isEnabled {
            return Color.Brand.gray
        }
        
        switch style {
        case .defaultStyle:
            return Color.Brand.white
        case .outline:
            return Color.Brand.primary
        }
    }

    private var borderColor: Color {
        if !isEnabled {
            return Color.Brand.gray.opacity(0.5)
        }
        
        switch style {
        case .defaultStyle:
            return Color.Brand.clear
        case .outline:
            return Color.Brand.primary
        }
    }

    var body: some View {
        Button {
            guard isEnabled, !isLoading else { return }
            
            action()
        } label: {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                } else {
                    Text(title)
                        .font(.brand(.bold))
                        .foregroundColor(textColor)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(borderColor, lineWidth: style == .outline ? 1 : 0)
            )
        }
        .disabled(isLoading || !isEnabled)
    }
}

#Preview {
    VStack(spacing: 16) {
        PRButton(title: "Enabled Default", style: .defaultStyle, isLoading: false, isEnabled: true) {
            print("Enabled Default button tapped")
        }

        PRButton(title: "Disabled Default", style: .defaultStyle, isLoading: false, isEnabled: false) {
            print("Disabled Default button tapped")
        }

        PRButton(title: "Enabled Outline", style: .outline, isLoading: false, isEnabled: true) {
            print("Enabled Outline button tapped")
        }

        PRButton(title: "Disabled Outline", style: .outline, isLoading: false, isEnabled: false) {
            print("Disabled Outline button tapped")
        }

        PRButton(title: "Loading", style: .defaultStyle, isLoading: true, isEnabled: true) {
            print("Loading button tapped")
        }
    }
    .padding()
}
