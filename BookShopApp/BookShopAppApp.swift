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
    
    init() {
        if ProcessInfo.processInfo.arguments.contains("RESET_SESSION") {
            UserDefaults.standard.removePersistentDomain(
                forName: Bundle.main.bundleIdentifier!
            )
        }
    }
    
    var body: some Scene {
        WindowGroup {

            if ProcessInfo.processInfo.arguments.contains("UI_TESTING") {
                NavigationStack {
                    LoginView()
                }
                .environmentObject(session)

            } else if session.currentUser != nil {
                MainTabView()
                    .environmentObject(session)

            } else {
                WelcomeView()
                    .environmentObject(session)
            }
        }
    }
}
