//
//  LoginView.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @EnvironmentObject private var session: SessionService
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome back")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: "1E1B4B"))

                    Text("Sign in to your account")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 8)

                // Fields
                VStack(spacing: 16) {
                    InputField(
                        title: "Email",
                        placeholder: "you@example.com",
                        text: $viewModel.loginEmail,
                        keyboardType: .emailAddress,
                        textContentType: .emailAddress
                    )
                    .accessibilityIdentifier("emailTextField")

                    InputField(
                        title: "Password",
                        placeholder: "Your password",
                        text: $viewModel.loginPassword,
                        isSecure: true,
                        textContentType: .password
                    )
                    .accessibilityIdentifier("passwordTextField")
                }

                // Error
                if let error = viewModel.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.circle.fill")
                        Text(error)
                            .font(.system(size: 14))
                    }
                    .accessibilityIdentifier("errorLabel")
                    .foregroundStyle(.red)
                    .padding(12)
                    .background(Color.red.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
                }

                // Action
                PrimaryButton(
                    title: "Sign In",
                    isLoading: viewModel.isLoading,
                    action: viewModel.login
                )
                .accessibilityIdentifier("loginButton")

                // Divider
                HStack {
                    Rectangle().fill(Color(.separator)).frame(height: 1)
                    Text("or").font(.system(size: 13)).foregroundStyle(.secondary)
                    Rectangle().fill(Color(.separator)).frame(height: 1)
                }

                // Register link
                NavigationLink(destination: RegisterView()) {
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundStyle(.secondary)
                        Text("Create one")
                            .foregroundStyle(Color.accent)
                            .fontWeight(.semibold)
                    }
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity)
                }
                .accessibilityIdentifier("registerButton")
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut(duration: 0.25), value: viewModel.errorMessage)
    }
}

#Preview("Login Light") {
    NavigationStack {
        LoginView()
    }
    .environmentObject(SessionService.shared)
}

#Preview("Login Dark") {
    NavigationStack {
        LoginView()
    }
    .environmentObject(SessionService.shared)
    .preferredColorScheme(.dark)
}
