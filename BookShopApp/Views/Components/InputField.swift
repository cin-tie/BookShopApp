//
//  InputField.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import SwiftUI

struct InputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil

    @State private var isRevealed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)

            ZStack(alignment: .trailing) {
                Group {
                    if isSecure && !isRevealed {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                            .keyboardType(keyboardType)
                            .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                            .autocorrectionDisabled(keyboardType == .emailAddress || isSecure)
                    }
                }
                .textContentType(textContentType)
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .padding(.trailing, isSecure ? 44 : 0)

                if isSecure {
                    Button {
                        isRevealed.toggle()
                    } label: {
                        Image(systemName: isRevealed ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                            .padding(.trailing, 14)
                    }
                }
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview("Input Fields") {
    VStack(spacing: 16) {
        InputField(title: "Email", placeholder: "you@example.com",
                   text: .constant(""), keyboardType: .emailAddress)
        InputField(title: "Password", placeholder: "Min. 8 characters",
                   text: .constant("secret"), isSecure: true)
    }
    .padding()
}
