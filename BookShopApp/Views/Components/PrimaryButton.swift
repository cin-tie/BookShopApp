//
//  PrimaryButton.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    var style: Style = .filled
    let action: () -> Void

    enum Style {
        case filled, outlined
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(style == .filled ? .white : Color.accent)
                } else {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(background)
            .foregroundStyle(foreground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.accent, lineWidth: style == .outlined ? 1.5 : 0)
            )
        }
        .disabled(isLoading)
    }

    private var background: Color {
        style == .filled ? Color.accent : Color.clear
    }

    private var foreground: Color {
        style == .filled ? .white : Color.accent
    }
}

extension Color {
    static let accent = Color(hex: "4F46E5")
    static let surfaceSecondary = Color(.systemGray6)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview("Primary Button") {
    VStack(spacing: 16) {
        PrimaryButton(title: "Get Started", action: {})
        PrimaryButton(title: "Sign In", style: .outlined, action: {})
        PrimaryButton(title: "Loading", isLoading: true, action: {})
    }
    .padding()
}
