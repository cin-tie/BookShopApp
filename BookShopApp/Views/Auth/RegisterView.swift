//
//  RegisterView.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    @EnvironmentObject private var session: SessionService
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Create account")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: "1E1B4B"))

                    Text("Join BookShop to start exploring")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 8)

                // Fields
                VStack(spacing: 16) {
                    InputField(
                        title: "Full Name",
                        placeholder: "John Doe",
                        text: $viewModel.registerName,
                        textContentType: .name
                    )
                    .accessibilityIdentifier("nameTextField")

                    InputField(
                        title: "Email",
                        placeholder: "you@example.com",
                        text: $viewModel.registerEmail,
                        keyboardType: .emailAddress,
                        textContentType: .emailAddress
                    )
                    .accessibilityIdentifier("registerEmailTextField")

                    InputField(
                        title: "Password",
                        placeholder: "Min. 8 characters",
                        text: $viewModel.registerPassword,
                        isSecure: true,
                        textContentType: .newPassword
                    )
                    .accessibilityIdentifier("registerPasswordTextField")

                    InputField(
                        title: "Confirm Password",
                        placeholder: "Repeat your password",
                        text: $viewModel.registerConfirm,
                        isSecure: true,
                        textContentType: .newPassword
                    )
                    .accessibilityIdentifier("confirmPasswordTextField")
                }

                // Password strength indicator
                if !viewModel.registerPassword.isEmpty {
                    PasswordStrengthView(password: viewModel.registerPassword)
                        .transition(.scale(scale: 0.95).combined(with: .opacity))
                }

                // Error
                if let error = viewModel.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.circle.fill")
                        Text(error)
                            .font(.system(size: 14))
                    }
                    .foregroundStyle(.red)
                    .padding(12)
                    .background(Color.red.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
                }

                // Action
                PrimaryButton(
                    title: "Create Account",
                    isLoading: viewModel.isLoading,
                    action: viewModel.register
                )
                .accessibilityIdentifier("createAccountButton")

                // Login link
                NavigationLink(destination: LoginView()) {
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundStyle(.secondary)
                        Text("Sign in")
                            .foregroundStyle(Color.accent)
                            .fontWeight(.semibold)
                    }
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut(duration: 0.25), value: viewModel.errorMessage)
        .animation(.easeInOut(duration: 0.2), value: viewModel.registerPassword.isEmpty)
    }
}

// MARK: - Password Strength

private struct PasswordStrengthView: View {
    let password: String

    private var strength: Int {
        var score = 0
        if password.count >= 8 { score += 1 }
        if password.count >= 12 { score += 1 }
        if password.range(of: "[A-Z]", options: .regularExpression) != nil { score += 1 }
        if password.range(of: "[0-9]", options: .regularExpression) != nil { score += 1 }
        return score
    }

    private var label: String {
        switch strength {
        case 0, 1: return "Weak"
        case 2: return "Fair"
        case 3: return "Good"
        default: return "Strong"
        }
    }

    private var color: Color {
        switch strength {
        case 0, 1: return .red
        case 2: return .orange
        case 3: return Color(hex: "22C55E")
        default: return Color(hex: "16A34A")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                ForEach(0..<4) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(i < strength ? color : Color(.systemGray5))
                        .frame(height: 4)
                        .animation(.easeInOut, value: strength)
                }
            }
            Text("Password strength: \(label)")
                .font(.system(size: 12))
                .foregroundStyle(color)
        }
    }
}

#Preview("Register Light") {
    NavigationStack {
        RegisterView()
    }
    .environmentObject(SessionService.shared)
}

#Preview("Register Dark") {
    NavigationStack {
        RegisterView()
    }
    .environmentObject(SessionService.shared)
    .preferredColorScheme(.dark)
}
