//
//  MainTabView.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var session: SessionService

    var body: some View {
        TabView {
            CatalogView()
                .tabItem {
                    Label("Shop", systemImage: "books.vertical.fill")
                }

            // Placeholder — реализуется в feature/cart-module
            NavigationStack {
                VStack(spacing: 16) {
                    Image(systemName: "cart")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.accent.opacity(0.4))
                    Text("Cart")
                        .font(.system(size: 20, weight: .semibold))
                    Text("Coming in next module")
                        .foregroundStyle(.secondary)
                }
                .navigationTitle("Cart")
            }
            .tabItem {
                Label("Cart", systemImage: "cart.fill")
            }

            // Placeholder — реализуется в feature/profile-module
            NavigationStack {
                VStack(spacing: 16) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.accent.opacity(0.4))
                    Text(session.currentUser?.name ?? "")
                        .font(.system(size: 20, weight: .semibold))
                    Button("Logout") { session.logout() }
                        .foregroundStyle(.red)
                }
                .navigationTitle("Profile")
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
        .tint(Color.accent)
    }
}

#Preview("Main Tab") {
    MainTabView()
        .environmentObject(SessionService.shared)
}
