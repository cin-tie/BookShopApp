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
                .accessibilityIdentifier("shopTab")

            CartView(viewModel: cartViewModel)
                .tabItem { Label("Cart", systemImage: "cart.fill") }
                .badge(cartViewModel.badgeCount > 0 ? cartViewModel.badgeCount : 0)
                .accessibilityIdentifier("cartTab")
            
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .accessibilityIdentifier("profile")
        }
        .tint(Color.accent)
        .onAppear { cartViewModel.loadCart() }
    }
}

#Preview("Main Tab") {
    MainTabView()
        .environmentObject(SessionService.shared)
}
