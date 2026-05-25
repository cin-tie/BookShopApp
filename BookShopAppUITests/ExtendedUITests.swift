// ExtendedUITests.swift
// BookShopAppUITests

import XCTest

final class ExtendedUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI_TESTING", "RESET_SESSION", "LOGGED_IN", "UI_TESTING_LOGGED_IN"]
        app.launch()
    }

    override func tearDown() {
        app.terminate()
        app = nil
        super.tearDown()
    }

    // MARK: - ProfileView

    func testProfileTabOpens() {
        app.tabBars.buttons["Profile"].tap()
        XCTAssertTrue(app.navigationBars["Profile"].waitForExistence(timeout: 3))
    }

    func testProfileShowsUserName() {
        app.tabBars.buttons["Profile"].tap()
        XCTAssertTrue(app.staticTexts["Test User"].waitForExistence(timeout: 3))
    }

    func testProfileShowsUserEmail() {
        app.tabBars.buttons["Profile"].tap()
        XCTAssertTrue(app.staticTexts["test@test.com"].waitForExistence(timeout: 3))
    }

    func testProfileShowsLogoutButton() {
        app.tabBars.buttons["Profile"].tap()
        XCTAssertTrue(app.buttons["Logout"].waitForExistence(timeout: 3))
    }

    // MARK: - ProductDetailView

    func testTapProductOpensDetail() {
        app.tabBars.buttons["Shop"].tap()
        // Ждём загрузки продуктов — ищем первую кнопку Add в каталоге
        let addBtn = app.buttons.matching(NSPredicate(format: "label == 'Add'")).firstMatch
        XCTAssertTrue(addBtn.waitForExistence(timeout: 10))
        // Тапаем на Image карточки (не на кнопку Add)
        // Карточки — это Image с identifier productCard_N
        let card = app.images.matching(NSPredicate(format: "identifier BEGINSWITH 'productCard_'")).firstMatch
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        card.tap()
        XCTAssertTrue(app.buttons["Add to Cart"].waitForExistence(timeout: 5))
    }

    func testProductDetailShowsAddToCartButton() {
        openFirstProductDetail()
        XCTAssertTrue(app.buttons["Add to Cart"].waitForExistence(timeout: 5))
    }

    func testProductDetailAddToCartAddsToCart() {
        openFirstProductDetail()
        let addBtn = app.buttons["Add to Cart"]
        guard addBtn.waitForExistence(timeout: 5) else { return }
        addBtn.tap()
        // Sheet закрывается, возвращаемся в каталог
        // Cart badge должен показать 1
        let cartTab = app.tabBars.buttons["Cart"]
        XCTAssertTrue(cartTab.waitForExistence(timeout: 3))
        XCTAssertEqual(cartTab.value as? String, "1 item")
    }

    func testProductDetailCanBeDismissed() {
        openFirstProductDetail()
        guard app.buttons["Add to Cart"].waitForExistence(timeout: 5) else { return }
        // Закрыть через свайп вниз
        let sheet = app.otherElements.matching(NSPredicate(format: "label CONTAINS 'Add to Cart'")).firstMatch
        if sheet.exists {
            app.swipeDown()
        } else {
            app.navigationBars.buttons.firstMatch.tap()
        }
        XCTAssertTrue(app.tabBars.buttons["Shop"].waitForExistence(timeout: 3))
    }

    // MARK: - OrdersListView

    func testOrdersListShowsNoOrdersWhenEmpty() {
        app.tabBars.buttons["Cart"].tap()
        _ = app.navigationBars["Cart"].waitForExistence(timeout: 3)
        app.buttons["clock.arrow.circlepath"].tap()
        XCTAssertTrue(app.staticTexts["No orders yet"].waitForExistence(timeout: 3))
    }

    func testOrdersListNavigationTitle() {
        app.tabBars.buttons["Cart"].tap()
        _ = app.navigationBars["Cart"].waitForExistence(timeout: 3)
        app.buttons["clock.arrow.circlepath"].tap()
        XCTAssertTrue(app.navigationBars["My Orders"].waitForExistence(timeout: 3))
    }

    func testOrdersHistoryButtonExistsInCart() {
        app.tabBars.buttons["Cart"].tap()
        _ = app.navigationBars["Cart"].waitForExistence(timeout: 3)
        XCTAssertTrue(app.buttons["clock.arrow.circlepath"].waitForExistence(timeout: 3))
    }

    // MARK: - Helpers

    private func openFirstProductDetail() {
        app.tabBars.buttons["Shop"].tap()
        // Ждём загрузки
        _ = app.buttons.matching(NSPredicate(format: "label == 'Add'")).firstMatch.waitForExistence(timeout: 10)
        // Тапаем на image карточки
        let card = app.images.matching(NSPredicate(format: "identifier BEGINSWITH 'productCard_'")).firstMatch
        guard card.waitForExistence(timeout: 5) else { return }
        card.tap()
        _ = app.buttons["Add to Cart"].waitForExistence(timeout: 5)
    }
}
