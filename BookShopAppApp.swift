//
//  BookShopAppApp.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import SwiftUI

@main
struct BookShopAppApp: App {
    @StateObject private var session = SessionService.shared

    var body: some Scene {
        WindowGroup {
            if session.currentUser != nil {
                // Placeholder until MainTabView is implemented
                Text("You're logged in as \(session.currentUser!.name)")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Logout") { session.logout() }
                        }
                    }
            } else {
                WelcomeView()
                    .environmentObject(session)
            }
        }
    }
}
