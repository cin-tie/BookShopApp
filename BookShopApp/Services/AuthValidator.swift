//
//  AuthValidator.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import Foundation

enum ValidationError: LocalizedError {
    case emptyField(String)
    case invalidEmail
    case weakPassword
    case passwordMismatch

    var errorDescription: String? {
        switch self {
        case .emptyField(let field): return "\(field) cannot be empty"
        case .invalidEmail:         return "Enter a valid email address"
        case .weakPassword:         return "Password must be at least 8 characters"
        case .passwordMismatch:     return "Passwords do not match"
        }
    }
}

struct AuthValidator {
    static func validateEmail(_ email: String) throws {
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { throw ValidationError.emptyField("Email") }
        let regex = #"^[A-Z0-9a-z._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
        guard trimmed.range(of: regex, options: .regularExpression) != nil else {
            throw ValidationError.invalidEmail
        }
    }

    static func validatePassword(_ password: String) throws {
        guard !password.isEmpty else { throw ValidationError.emptyField("Password") }
        guard password.count >= 8 else { throw ValidationError.weakPassword }
    }

    static func validatePasswordMatch(_ password: String, _ confirm: String) throws {
        guard password == confirm else { throw ValidationError.passwordMismatch }
    }

    static func validateName(_ name: String) throws {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ValidationError.emptyField("Name")
        }
    }
}
