//
//  SessionService.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import Foundation

final class SessionService: ObservableObject {
    static let shared = SessionService()

    private let userKey = "session_user"
    private let allUsersKey = "all_users"

    @Published private(set) var currentUser: User?

    private init() {
        restoreSession()
    }

    // MARK: - Session

    private func restoreSession() {
        guard let data = UserDefaults.standard.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: data)
        else { return }
        currentUser = user
    }

    func logout() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: userKey)
    }

    // MARK: - Auth

    /// Returns error string or nil on success
    func register(name: String, email: String, password: String, confirm: String) -> String? {
        do {
            try AuthValidator.validateName(name)
            try AuthValidator.validateEmail(email)
            try AuthValidator.validatePassword(password)
            try AuthValidator.validatePasswordMatch(password, confirm)
        } catch {
            return error.localizedDescription
        }

        var users = loadAllUsers()
        if users.contains(where: { $0.email.lowercased() == email.lowercased() }) {
            return "An account with this email already exists"
        }

        let user = User(name: name, email: email)
        users.append(user)
        saveAllUsers(users)
        saveSession(user)
        return nil
    }

    func login(email: String, password: String) -> String? {
        do {
            try AuthValidator.validateEmail(email)
            try AuthValidator.validatePassword(password)
        } catch {
            return error.localizedDescription
        }

        let users = loadAllUsers()
        guard let user = users.first(where: { $0.email.lowercased() == email.lowercased() }) else {
            return "No account found with this email"
        }

        // NOTE: In production use hashed passwords. This is local demo storage.
        saveSession(user)
        return nil
    }

    // MARK: - Private Helpers

    private func saveSession(_ user: User) {
        currentUser = user
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userKey)
        }
        let numericKey = "user_numeric_id_\(user.email)"
        if UserDefaults.standard.integer(forKey: numericKey) == 0 {
            let stableId = abs(user.email.hashValue) % 1_000_000 + 1
            UserDefaults.standard.set(stableId, forKey: numericKey)
        }
    }

    func numericUserId() -> Int {
        guard let user = currentUser else { return 0 }
        let key = "user_numeric_id_\(user.email)"
        return UserDefaults.standard.integer(forKey: key)
    }
    private func loadAllUsers() -> [User] {
        guard let data = UserDefaults.standard.data(forKey: allUsersKey),
              let users = try? JSONDecoder().decode([User].self, from: data)
        else { return [] }
        return users
    }

    private func saveAllUsers(_ users: [User]) {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: allUsersKey)
        }
    }
}
