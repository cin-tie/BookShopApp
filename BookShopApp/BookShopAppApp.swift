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
                MainTabView()
                    .environmentObject(session)
            } else {
                WelcomeView()
                    .environmentObject(session)
            }
        }
    }
}
