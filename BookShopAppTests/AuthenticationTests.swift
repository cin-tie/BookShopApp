// AuthenticationTests.swift
// BookShopApp – Unit Tests
// Covers: login validation, empty fields, password validation, logout, session restore

import XCTest
@testable import BookShopApp

// MARK: - AuthenticationTests

final class AuthenticationTests: XCTestCase {

    var authViewModel: AuthViewModel!
    var mockUserService: MockUserService!

    // MARK: Setup / Teardown

    override func setUp() {
        super.setUp()
        mockUserService = MockUserService()
        authViewModel = AuthViewModel(userService: mockUserService)
    }

    override func tearDown() {
        authViewModel = nil
        mockUserService = nil
        super.tearDown()
    }

    // MARK: - Login Validation

    func testLoginWithValidCredentialsSucceeds() {
        // Given
        mockUserService.stubbedLoginResult = .success(User.stub())
        authViewModel.email = "user@example.com"
        authViewModel.password = "ValidPass1!"

        // When
        authViewModel.login()

        // Then
        XCTAssertTrue(authViewModel.isLoggedIn)
        XCTAssertNil(authViewModel.errorMessage)
    }

    func testLoginWithInvalidCredentialsFails() {
        // Given
        mockUserService.stubbedLoginResult = .failure(AuthError.invalidCredentials)
        authViewModel.email = "user@example.com"
        authViewModel.password = "WrongPass"

        // When
        authViewModel.login()

        // Then
        XCTAssertFalse(authViewModel.isLoggedIn)
        XCTAssertNotNil(authViewModel.errorMessage)
    }

    func testLoginWithMalformedEmailFails() {
        authViewModel.email = "notAnEmail"
        authViewModel.password = "ValidPass1!"
        authViewModel.login()
        XCTAssertFalse(authViewModel.isLoggedIn)
        XCTAssertEqual(authViewModel.errorMessage, AuthError.invalidEmail.localizedDescription)
    }

    // MARK: - Empty Fields

    func testLoginWithEmptyEmailShowsError() {
        authViewModel.email = ""
        authViewModel.password = "ValidPass1!"
        authViewModel.login()
        XCTAssertFalse(authViewModel.isLoggedIn)
        XCTAssertEqual(authViewModel.errorMessage, AuthError.emptyEmail.localizedDescription)
    }

    func testLoginWithEmptyPasswordShowsError() {
        authViewModel.email = "user@example.com"
        authViewModel.password = ""
        authViewModel.login()
        XCTAssertFalse(authViewModel.isLoggedIn)
        XCTAssertEqual(authViewModel.errorMessage, AuthError.emptyPassword.localizedDescription)
    }

    func testLoginWithBothFieldsEmptyShowsError() {
        authViewModel.email = ""
        authViewModel.password = ""
        authViewModel.login()
        XCTAssertFalse(authViewModel.isLoggedIn)
        XCTAssertNotNil(authViewModel.errorMessage)
    }

    func testLoginWithWhitespaceOnlyEmailFails() {
        authViewModel.email = "   "
        authViewModel.password = "ValidPass1!"
        authViewModel.login()
        XCTAssertFalse(authViewModel.isLoggedIn)
    }

    // MARK: - Password Validation

    func testPasswordTooShortFails() {
        // Minimum 8 characters
        authViewModel.email = "user@example.com"
        authViewModel.password = "Ab1!"
        authViewModel.login()
        XCTAssertFalse(authViewModel.isLoggedIn)
        XCTAssertEqual(authViewModel.errorMessage, AuthError.passwordTooShort.localizedDescription)
    }

    func testPasswordWithoutUppercaseFails() {
        authViewModel.email = "user@example.com"
        authViewModel.password = "validpass1!"
        authViewModel.login()
        XCTAssertFalse(authViewModel.isLoggedIn)
    }

    func testPasswordWithoutDigitFails() {
        authViewModel.email = "user@example.com"
        authViewModel.password = "ValidPass!"
        authViewModel.login()
        XCTAssertFalse(authViewModel.isLoggedIn)
    }

    func testPasswordValidatorAcceptsStrongPassword() {
        let validator = PasswordValidator()
        XCTAssertTrue(validator.isValid("StrongPass1!"))
    }

    func testPasswordValidatorRejectsWeakPassword() {
        let validator = PasswordValidator()
        XCTAssertFalse(validator.isValid("weak"))
    }

    // MARK: - Logout

    func testLogoutClearsSession() {
        // Given – user is logged in
        mockUserService.stubbedLoginResult = .success(User.stub())
        authViewModel.email = "user@example.com"
        authViewModel.password = "ValidPass1!"
        authViewModel.login()
        XCTAssertTrue(authViewModel.isLoggedIn)

        // When
        authViewModel.logout()

        // Then
        XCTAssertFalse(authViewModel.isLoggedIn)
        XCTAssertNil(authViewModel.currentUser)
    }

    func testLogoutRemovesTokenFromStorage() {
        mockUserService.stubbedLoginResult = .success(User.stub())
        authViewModel.email = "user@example.com"
        authViewModel.password = "ValidPass1!"
        authViewModel.login()
        authViewModel.logout()
        XCTAssertFalse(mockUserService.sessionTokenExists())
    }

    // MARK: - Session Restore

    func testSessionRestoresOnAppLaunchWhenTokenExists() {
        // Given – simulate a previously saved token
        mockUserService.stubbedSessionUser = User.stub()

        // When – new viewModel tries to restore
        let newViewModel = AuthViewModel(userService: mockUserService)
        newViewModel.restoreSession()

        // Then
        XCTAssertTrue(newViewModel.isLoggedIn)
        XCTAssertNotNil(newViewModel.currentUser)
    }

    func testSessionNotRestoredWhenNoTokenExists() {
        mockUserService.stubbedSessionUser = nil
        let newViewModel = AuthViewModel(userService: mockUserService)
        newViewModel.restoreSession()
        XCTAssertFalse(newViewModel.isLoggedIn)
    }
}

// MARK: - Supporting Mocks & Stubs

/// Represents a minimal User model for test stubs.
struct User {
    let id: String
    let email: String
    let name: String

    static func stub(
        id: String = "user-1",
        email: String = "user@example.com",
        name: String = "Test User"
    ) -> User {
        User(id: id, email: email, name: name)
    }
}

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case invalidEmail
    case emptyEmail
    case emptyPassword
    case passwordTooShort

    var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "Invalid email or password."
        case .invalidEmail:       return "Please enter a valid email address."
        case .emptyEmail:         return "Email cannot be empty."
        case .emptyPassword:      return "Password cannot be empty."
        case .passwordTooShort:   return "Password must be at least 8 characters."
        }
    }
}

protocol UserServiceProtocol {
    func login(email: String, password: String) -> Result<User, Error>
    func logout()
    func sessionTokenExists() -> Bool
    func currentSessionUser() -> User?
}

class MockUserService: UserServiceProtocol {
    var stubbedLoginResult: Result<User, Error> = .failure(AuthError.invalidCredentials)
    var stubbedSessionUser: User?

    func login(email: String, password: String) -> Result<User, Error> { stubbedLoginResult }
    func logout() { stubbedSessionUser = nil }
    func sessionTokenExists() -> Bool { stubbedSessionUser != nil }
    func currentSessionUser() -> User? { stubbedSessionUser }
}

struct PasswordValidator {
    /// At least 8 chars, one uppercase letter, one digit.
    func isValid(_ password: String) -> Bool {
        guard password.count >= 8 else { return false }
        let hasUpper = password.contains(where: \.isUppercase)
        let hasDigit = password.contains(where: \.isNumber)
        return hasUpper && hasDigit
    }
}

/// Minimal stand-in ViewModel; replace with your real AuthViewModel.
class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?
    @Published var currentUser: User?

    private let userService: UserServiceProtocol
    private let passwordValidator = PasswordValidator()

    init(userService: UserServiceProtocol) {
        self.userService = userService
    }

    func login() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        let trimmedPassword = password.trimmingCharacters(in: .whitespaces)

        guard !trimmedEmail.isEmpty else {
            errorMessage = AuthError.emptyEmail.localizedDescription; return
        }
        guard !trimmedPassword.isEmpty else {
            errorMessage = AuthError.emptyPassword.localizedDescription; return
        }
        guard trimmedEmail.contains("@") && trimmedEmail.contains(".") else {
            errorMessage = AuthError.invalidEmail.localizedDescription; return
        }
        guard passwordValidator.isValid(trimmedPassword) else {
            errorMessage = AuthError.passwordTooShort.localizedDescription; return
        }

        switch userService.login(email: trimmedEmail, password: trimmedPassword) {
        case .success(let user):
            currentUser = user
            isLoggedIn = true
            errorMessage = nil
        case .failure(let error):
            isLoggedIn = false
            errorMessage = error.localizedDescription
        }
    }

    func logout() {
        userService.logout()
        isLoggedIn = false
        currentUser = nil
        errorMessage = nil
    }

    func restoreSession() {
        if let user = userService.currentSessionUser() {
            currentUser = user
            isLoggedIn = true
        }
    }
}
