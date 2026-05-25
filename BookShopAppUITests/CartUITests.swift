// CartUITests.swift
// BookShopAppUITests

import XCTest

final class CartUITests: XCTestCase {
    
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
    
    // MARK: - Пустая корзина
    
    func testEmptyCartShowsPlaceholderMessage() {
        openCart()
        XCTAssertTrue(app.staticTexts["Your cart is empty"].waitForExistence(timeout: 5))
    }
    
    func testCheckoutButtonNotVisibleWhenCartEmpty() {
        openCart()
        _ = app.staticTexts["Your cart is empty"].waitForExistence(timeout: 3)
        let checkout = app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Checkout'")).firstMatch
        XCTAssertFalse(checkout.exists)
    }
    
    // MARK: - Добавление товара
    
    func testAddProductAppearsInCart() {
        addFirstProduct()
        openCart()
        XCTAssertFalse(app.staticTexts["Your cart is empty"].waitForExistence(timeout: 2))
    }
    
    func testEmptyLabelDisappearsAfterAddingProduct() {
        addFirstProduct()
        openCart()
        XCTAssertFalse(app.staticTexts["Your cart is empty"].exists)
    }
    
    func testCheckoutButtonExistsAfterAddingProduct() {
        addFirstProduct()
        openCart()
        // Checkout button label: "Checkout — $12.99"
        let checkout = app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Checkout'")).firstMatch
        XCTAssertTrue(checkout.waitForExistence(timeout: 5))
    }
    
    // MARK: - Stepper
    
    func testIncreaseQuantityWorks() {
        addFirstProduct()
        openCart()
        // incrementButton label == "Add"
        let plus = app.buttons.matching(NSPredicate(format: "label == 'Add' AND identifier == 'incrementButton'")).firstMatch
        XCTAssertTrue(plus.waitForExistence(timeout: 5))
        plus.tap()
        XCTAssertTrue(app.staticTexts["2"].waitForExistence(timeout: 2))
    }
    
    func testDecreaseQuantityWorks() {
        addFirstProduct()
        openCart()
        // Сначала увеличить до 2
        let plus = app.buttons.matching(NSPredicate(format: "label == 'Add' AND identifier == 'incrementButton'")).firstMatch
        XCTAssertTrue(plus.waitForExistence(timeout: 5))
        plus.tap()
        _ = app.staticTexts["2"].waitForExistence(timeout: 2)
        // decrementButton label == "Remove"
        let minus = app.buttons.matching(NSPredicate(format: "label == 'Remove' AND identifier == 'decrementButton'")).firstMatch
        XCTAssertTrue(minus.waitForExistence(timeout: 3))
        minus.tap()
        XCTAssertTrue(app.staticTexts["1"].waitForExistence(timeout: 2))
    }
    
    func testRemoveButtonDeletesItem() {
        addFirstProduct()
        openCart()
        // removeButton label == "Trash"
        let trash = app.buttons.matching(NSPredicate(format: "label == 'Trash'")).firstMatch
        XCTAssertTrue(trash.waitForExistence(timeout: 5))
        trash.tap()
        XCTAssertTrue(app.staticTexts["Your cart is empty"].waitForExistence(timeout: 3))
    }
    
    // MARK: - Checkout
    
    func testCheckoutButtonOpensCheckout() {
        addFirstProduct()
        openCart()
        let checkout = app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Checkout'")).firstMatch
        XCTAssertTrue(checkout.waitForExistence(timeout: 5))
        checkout.tap()
        XCTAssertTrue(app.navigationBars["Checkout"].waitForExistence(timeout: 5))
    }
    
    // MARK: - Helpers
    
    private func openCart() {
        app.tabBars.buttons["Cart"].tap()
        _ = app.navigationBars["Cart"].waitForExistence(timeout: 5)
    }
    private func addFirstProduct() {
        app.tabBars.buttons["Shop"].tap()
        // addToCartButton в ProductCard имеет label "Add"
        // но нам нужна именно кнопка из карточки, не из корзины
        // ищем по identifier productCard_ чтобы не перепутать с incrementButton
        let addButton = app.buttons.matching(
            NSPredicate(format: "label == 'Add' AND identifier != 'incrementButton'")
        ).firstMatch
        XCTAssertTrue(addButton.waitForExistence(timeout: 10))
        addButton.tap()
    }
}
