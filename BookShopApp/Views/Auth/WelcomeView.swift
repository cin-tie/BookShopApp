//
//  WelcomeView.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import SwiftUI

struct WelcomeView: View {
    @State private var navigateToLogin = false
    @State private var navigateToRegister = false
    @State private var appear = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "EEF2FF"), Color(hex: "F5F3FF"), .white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Circle()
                    .fill(Color.accent.opacity(0.08))
                    .frame(width: 380)
                    .offset(x: 120, y: -200)
                    .blur(radius: 1)

                VStack(spacing: 0) {
                    Spacer()

                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.accent)
                                .frame(width: 88, height: 88)
                                .shadow(color: Color.accent.opacity(0.35), radius: 20, y: 8)

                            Image(systemName: "books.vertical.fill")
                                .font(.system(size: 38))
                                .foregroundStyle(.white)
                        }
                        .scaleEffect(appear ? 1 : 0.6)
                        .opacity(appear ? 1 : 0)

                        VStack(spacing: 8) {
                            Text("BookShop")
                                .font(.system(size: 38, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(hex: "1E1B4B"))

                            Text("Your personal book store.\nDiscover, collect, enjoy.")
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                        }
                        .offset(y: appear ? 0 : 16)
                        .opacity(appear ? 1 : 0)
                    }

                    Spacer()

                    VStack(spacing: 12) {
                        PrimaryButton(title: "Get Started") {
                            navigateToRegister = true
                        }

                        PrimaryButton(title: "Sign In", style: .outlined) {
                            navigateToLogin = true
                        }

                        Text("By continuing you agree to our Terms of Service")
                            .font(.system(size: 12))
                            .foregroundStyle(Color(.tertiaryLabel))
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }
                    .padding(.horizontal, 24)
                    .offset(y: appear ? 0 : 30)
                    .opacity(appear ? 1 : 0)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToRegister) {
                RegisterView()
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.1)) {
                    appear = true
                }
            }
        }
    }
}

#Preview("Welcome Light") {
    WelcomeView()
        .environmentObject(SessionService.shared)
}

#Preview("Welcome Dark") {
    WelcomeView()
        .environmentObject(SessionService.shared)
        .preferredColorScheme(.dark)
}
