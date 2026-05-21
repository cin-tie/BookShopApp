//
//  MainTabView.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var session: SessionService
    @StateObject private var cartViewModel = CartViewModel()

    var body: some View {
        TabView {
            CatalogView(cartViewModel: cartViewModel)
                .tabItem { Label("Shop", systemImage: "books.vertical.fill") }

            CartView(viewModel: cartViewModel)
                .tabItem { Label("Cart", systemImage: "cart.fill") }
                .badge(cartViewModel.badgeCount > 0 ? cartViewModel.badgeCount : 0)

            profileTab
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(Color.accent)
        .onAppear { cartViewModel.loadCart() }
    }

    private var profileTab: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(Color.accent.opacity(0.35))
                VStack(spacing: 4) {
                    Text(session.currentUser?.name ?? "")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    Text(session.currentUser?.email ?? "")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                PrimaryButton(title: "Logout", style: .outlined) {
                    session.logout()
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview("Main Tab") {
    MainTabView()
        .environmentObject(SessionService.shared)
}
