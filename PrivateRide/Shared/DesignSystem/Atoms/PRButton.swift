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
    let action: () -> Void

    private var backgroundColor: Color {
        switch style {
        case .defaultStyle:
            return Color.Brand.primary
        case .outline:
            return Color.Brand.clear
        }
    }

    private var textColor: Color {
        switch style {
        case .defaultStyle:
            return Color.Brand.white
        case .outline:
            return Color.Brand.primary
        }
    }

    private var borderColor: Color {
        switch style {
        case .defaultStyle:
            return Color.Brand.clear
        case .outline:
            return Color.Brand.primary
        }
    }

    var body: some View {
        Button {
            guard !isLoading else { return }
            
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
        .disabled(isLoading)
    }
}

#Preview {
    VStack(spacing: 16) {
        PRButton(title: "Default", style: .defaultStyle, isLoading: false) {
            print("Default button tapped")
        }

        PRButton(title: "Outline", style: .outline, isLoading: true) {
            print("Outline button tapped")
        }
    }
    .padding()
}
