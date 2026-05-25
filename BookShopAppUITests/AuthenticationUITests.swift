
import XCTest

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

        if !email.isEmpty {
            emailField.tap()
            emailField.typeText(email)
        }

        if !password.isEmpty {
            passwordField.tap()
            passwordField.typeText(password)
        }

        loginButton.tap()
    }

    private func openShopTab() {
        // 🔥 самый стабильный вариант — identifier
        let shopById = app.buttons["shopTab"]

        if shopById.waitForExistence(timeout: 3) {
            shopById.tap()
            return
        }

        // fallback — если identifier не прокинулся в TabBar
        let shopByText = app.tabBars.buttons["Shop"]
        XCTAssertTrue(shopByText.waitForExistence(timeout: 5))
        shopByText.tap()
    }

    // MARK: - Tests

    func testLoginScreenIsDisplayedOnLaunch() {
        XCTAssertTrue(app.textFields["emailTextField"].exists)
        XCTAssertTrue(app.secureTextFields["passwordTextField"].exists)
        XCTAssertTrue(app.buttons["loginButton"].exists)
        XCTAssertTrue(app.buttons["registerButton"].exists)
    }

    func testRegisterButtonExists() {
        XCTAssertTrue(app.buttons["registerButton"].waitForExistence(timeout: 5))
    }

    func testLoginWithEmptyEmailShowsError() {
        login(email: "", password: "")
        XCTAssertTrue(app.staticTexts["errorLabel"].waitForExistence(timeout: 5))
    }

    func testLoginWithEmptyPasswordShowsError() {
        login(email: "test@mail.com", password: "")
        XCTAssertTrue(app.staticTexts["errorLabel"].waitForExistence(timeout: 5))
    }

    func testLoginWithInvalidCredentialsShowsError() {
        login(email: "wrong", password: "123")
        XCTAssertTrue(app.staticTexts["errorLabel"].waitForExistence(timeout: 5))
    }
}
