//
//  AuthViewModel.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    // MARK: - Login Fields
    @Published var loginEmail = ""
    @Published var loginPassword = ""

    // MARK: - Register Fields
    @Published var registerName = ""
    @Published var registerEmail = ""
    @Published var registerPassword = ""
    @Published var registerConfirm = ""

    // MARK: - State
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let session = SessionService.shared

    func login() {
        isLoading = true
        errorMessage = nil
        // Simulate slight async feel
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }
            self.errorMessage = self.session.login(email: self.loginEmail, password: self.loginPassword)
            self.isLoading = false
        }
    }

    func register() {
        isLoading = true
        errorMessage = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }
            self.errorMessage = self.session.register(
                name: self.registerName,
                email: self.registerEmail,
                password: self.registerPassword,
                confirm: self.registerConfirm
            )
            self.isLoading = false
        }
    }

    func clearErrors() {
        errorMessage = nil
    }
}
