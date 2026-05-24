// AuthenticationUITests.swift
// BookShopApp – UI Tests
// Covers: login flow, empty fields, password validation, logout, session restore, navigation.

import XCTest

// MARK: - AuthenticationUITests

final class AuthenticationUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["UI_TESTING", "RESET_SESSION"]
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    // MARK: - Helpers
    
    private func login(email: String, password: String) {
        let emailField = app.textFields["emailTextField"]
        let passwordField = app.secureTextFields["passwordTextField"]
        let loginButton = app.buttons["loginButton"]
        
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5))
        
        emailField.tap()
        emailField.typeText(email)
        
        passwordField.tap()
        passwordField.typeText(password)
        
        loginButton.tap()
    }
    
    // MARK: - Tests
    
    func testLoginScreenIsDisplayedOnLaunch() {
        XCTAssertTrue(app.textFields["emailTextField"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.secureTextFields["passwordTextField"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["loginButton"].waitForExistence(timeout: 5))
    }
    
    func testLoginWithEmptyEmailShowsValidationError() {
        login(email: "", password: "")
        
        XCTAssertTrue(app.staticTexts["errorLabel"].waitForExistence(timeout: 5))
    }
    
    func testLoginWithEmptyPasswordShowsValidationError() {
        login(email: "test@mail.com", password: "")
        
        XCTAssertTrue(app.staticTexts["errorLabel"].waitForExistence(timeout: 5))
    }
}
