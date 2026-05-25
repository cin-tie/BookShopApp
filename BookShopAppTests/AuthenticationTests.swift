// AuthenticationTests.swift
// BookShopAppTests — Unit Tests

import XCTest
@testable import BookShopApp

// MARK: - AuthValidator

final class AuthValidatorTests: XCTestCase {

    func testValidEmailPassesValidation() {
        XCTAssertNoThrow(try AuthValidator.validateEmail("user@example.com"))
    }

    func testEmptyEmailThrowsError() {
        XCTAssertThrowsError(try AuthValidator.validateEmail("")) { error in
            XCTAssertEqual(error.localizedDescription, "Email cannot be empty")
        }
    }

    func testWhitespaceEmailThrowsError() {
        XCTAssertThrowsError(try AuthValidator.validateEmail("   "))
    }

    func testInvalidEmailThrowsError() {
        XCTAssertThrowsError(try AuthValidator.validateEmail("notanemail")) { error in
            XCTAssertEqual(error.localizedDescription, "Enter a valid email address")
        }
    }

    func testEmailWithoutDomainThrowsError() {
        XCTAssertThrowsError(try AuthValidator.validateEmail("user@"))
    }

    func testValidPasswordPassesValidation() {
        XCTAssertNoThrow(try AuthValidator.validatePassword("strongpass"))
    }

    func testEmptyPasswordThrowsError() {
        XCTAssertThrowsError(try AuthValidator.validatePassword("")) { error in
            XCTAssertEqual(error.localizedDescription, "Password cannot be empty")
        }
    }

    func testShortPasswordThrowsError() {
        XCTAssertThrowsError(try AuthValidator.validatePassword("1234567")) { error in
            XCTAssertEqual(error.localizedDescription, "Password must be at least 8 characters")
        }
    }

    func testPasswordExactly8CharsPassesValidation() {
        XCTAssertNoThrow(try AuthValidator.validatePassword("12345678"))
    }

    func testMatchingPasswordsPassValidation() {
        XCTAssertNoThrow(try AuthValidator.validatePasswordMatch("password", "password"))
    }

    func testMismatchedPasswordsThrowError() {
        XCTAssertThrowsError(try AuthValidator.validatePasswordMatch("password", "different")) { error in
            XCTAssertEqual(error.localizedDescription, "Passwords do not match")
        }
    }

    func testValidNamePassesValidation() {
        XCTAssertNoThrow(try AuthValidator.validateName("Maria"))
    }

    func testEmptyNameThrowsError() {
        XCTAssertThrowsError(try AuthValidator.validateName("")) { error in
            XCTAssertEqual(error.localizedDescription, "Name cannot be empty")
        }
    }

    func testWhitespaceNameThrowsError() {
        XCTAssertThrowsError(try AuthValidator.validateName("   "))
    }
}

// MARK: - SessionService

final class SessionServiceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        SessionService.shared.logout()
        UserDefaults.standard.removeObject(forKey: "all_users")
        UserDefaults.standard.removeObject(forKey: "session_user")
    }

    override func tearDown() {
        SessionService.shared.logout()
        UserDefaults.standard.removeObject(forKey: "all_users")
        UserDefaults.standard.removeObject(forKey: "session_user")
        super.tearDown()
    }

    func testRegisterWithValidDataSucceeds() {
        let error = SessionService.shared.register(
            name: "Test User", email: uniqueEmail(),
            password: "password123", confirm: "password123"
        )
        XCTAssertNil(error)
        XCTAssertNotNil(SessionService.shared.currentUser)
    }

    func testRegisterSetsCurrentUser() {
        let email = uniqueEmail()
        _ = SessionService.shared.register(name: "Test", email: email, password: "pass1234", confirm: "pass1234")
        XCTAssertEqual(SessionService.shared.currentUser?.email, email)
    }

    func testRegisterWithEmptyNameReturnsError() {
        let error = SessionService.shared.register(name: "", email: uniqueEmail(), password: "pass1234", confirm: "pass1234")
        XCTAssertNotNil(error)
    }

    func testRegisterWithInvalidEmailReturnsError() {
        let error = SessionService.shared.register(name: "User", email: "bad-email", password: "pass1234", confirm: "pass1234")
        XCTAssertNotNil(error)
    }

    func testRegisterWithShortPasswordReturnsError() {
        let error = SessionService.shared.register(name: "User", email: uniqueEmail(), password: "123", confirm: "123")
        XCTAssertNotNil(error)
    }

    func testRegisterWithMismatchedPasswordsReturnsError() {
        let error = SessionService.shared.register(name: "User", email: uniqueEmail(), password: "pass1234", confirm: "different")
        XCTAssertNotNil(error)
    }

    func testRegisterDuplicateEmailReturnsError() {
        let email = uniqueEmail()
        _ = SessionService.shared.register(name: "User1", email: email, password: "pass1234", confirm: "pass1234")
        SessionService.shared.logout()
        let error = SessionService.shared.register(name: "User2", email: email, password: "pass1234", confirm: "pass1234")
        XCTAssertNotNil(error)
        XCTAssertTrue(error?.contains("already exists") == true)
    }

    func testLoginWithRegisteredEmailSucceeds() {
        let email = uniqueEmail()
        _ = SessionService.shared.register(name: "User", email: email, password: "pass1234", confirm: "pass1234")
        SessionService.shared.logout()
        let error = SessionService.shared.login(email: email, password: "pass1234")
        XCTAssertNil(error)
        XCTAssertNotNil(SessionService.shared.currentUser)
    }

    func testLoginWithUnknownEmailReturnsError() {
        let error = SessionService.shared.login(email: "nobody@nowhere.com", password: "pass1234")
        XCTAssertNotNil(error)
        XCTAssertNil(SessionService.shared.currentUser)
    }

    func testLoginWithEmptyEmailReturnsError() {
        let error = SessionService.shared.login(email: "", password: "pass1234")
        XCTAssertNotNil(error)
    }

    func testLoginWithEmptyPasswordReturnsError() {
        let error = SessionService.shared.login(email: uniqueEmail(), password: "")
        XCTAssertNotNil(error)
    }

    func testLogoutClearsCurrentUser() {
        _ = SessionService.shared.register(name: "User", email: uniqueEmail(), password: "pass1234", confirm: "pass1234")
        XCTAssertNotNil(SessionService.shared.currentUser)
        SessionService.shared.logout()
        XCTAssertNil(SessionService.shared.currentUser)
    }

    func testLogoutRemovesSessionFromUserDefaults() {
        _ = SessionService.shared.register(name: "User", email: uniqueEmail(), password: "pass1234", confirm: "pass1234")
        SessionService.shared.logout()
        XCTAssertNil(UserDefaults.standard.data(forKey: "session_user"))
    }

    private func uniqueEmail() -> String {
        "test_\(UUID().uuidString.prefix(8))@test.com"
    }
}
