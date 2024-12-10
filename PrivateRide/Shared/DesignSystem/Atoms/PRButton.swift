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
            action()
        } label: {
            Text(title)
                .font(.brand(.bold))
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .foregroundColor(textColor)
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(borderColor, lineWidth: style == .outline ? 1 : 0)
                )
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        PRButton(title: "Default", style: .defaultStyle) {
            print("Default button tapped")
        }

        PRButton(title: "Outline", style: .outline) {
            print("Outline button tapped")
        }
    }
    .padding()
}
