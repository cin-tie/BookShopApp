// CartTests.swift
// BookShopAppTests — Unit Tests
// Используем реальный первый продукт из БД (id=1, price=14.99)

import XCTest
@testable import BookShopApp

@MainActor
final class CartTests: XCTestCase {

    var cartVM: CartViewModel!
    let session = SessionService.shared

    override func setUp() {
        super.setUp()
        // Чистим UserDefaults и регистрируем тестового пользователя
        session.logout()
        UserDefaults.standard.removeObject(forKey: "all_users")
        UserDefaults.standard.removeObject(forKey: "session_user")
        _ = session.register(
            name: "Cart User",
            email: "cart_\(UUID().uuidString.prefix(6))@test.com",
            password: "pass1234",
            confirm: "pass1234"
        )
        cartVM = CartViewModel()
        // Очищаем корзину перед каждым тестом
        CartRepository.shared.clearCart(userId: session.stableUserId())
        cartVM.loadCart()
    }

    override func tearDown() {
        CartRepository.shared.clearCart(userId: session.stableUserId())
        session.logout()
        UserDefaults.standard.removeObject(forKey: "all_users")
        UserDefaults.standard.removeObject(forKey: "session_user")
        super.tearDown()
    }

    // MARK: - Пустая корзина

    func testCartIsEmptyOnStart() {
        XCTAssertTrue(cartVM.items.isEmpty)
    }

    func testTotalIsZeroForEmptyCart() {
        XCTAssertEqual(cartVM.total, 0.0)
    }

    func testBadgeCountIsZeroForEmptyCart() {
        XCTAssertEqual(cartVM.badgeCount, 0)
    }

    func testPlaceOrderDoesNothingWhenCartEmpty() {
        cartVM.placeOrder()
        XCTAssertNil(cartVM.placedOrder)
    }

    // MARK: - Добавление (продукт id=1 реально существует в БД, price=14.99)

    func testAddProductIncreasesItemCount() {
        cartVM.addProduct(realProduct())
        XCTAssertEqual(cartVM.items.count, 1)
    }

    func testAddSameProductTwiceIncreasesQuantity() {
        cartVM.addProduct(realProduct())
        cartVM.addProduct(realProduct())
        XCTAssertEqual(cartVM.items.count, 1)
        XCTAssertEqual(cartVM.items.first?.quantity, 2)
    }

    func testAddTwoDifferentProductsCreatesTwoItems() {
        cartVM.addProduct(realProduct(id: 1))
        cartVM.addProduct(realProduct(id: 2))
        XCTAssertEqual(cartVM.items.count, 2)
    }

    func testBadgeCountUpdatesAfterAdding() {
        cartVM.addProduct(realProduct())
        cartVM.addProduct(realProduct())
        XCTAssertEqual(cartVM.badgeCount, 2)
    }

    func testTotalIsPositiveAfterAddingProduct() {
        cartVM.addProduct(realProduct())
        XCTAssertGreaterThan(cartVM.total, 0)
    }

    // MARK: - Изменение количества

    func testIncrementIncreasesQuantityByOne() {
        cartVM.addProduct(realProduct())
        let item = cartVM.items.first!
        cartVM.increment(item: item)
        XCTAssertEqual(cartVM.items.first?.quantity, 2)
    }

    func testDecrementDecreasesQuantityByOne() {
        cartVM.addProduct(realProduct())
        cartVM.addProduct(realProduct()) // qty = 2
        let item = cartVM.items.first!
        cartVM.decrement(item: item)
        XCTAssertEqual(cartVM.items.first?.quantity, 1)
    }

    func testDecrementAtOneDoesNotRemoveItem() {
        // CartViewModel.decrement: guard item.quantity > 1 else { return }
        cartVM.addProduct(realProduct())
        let item = cartVM.items.first!
        cartVM.decrement(item: item)
        XCTAssertEqual(cartVM.items.first?.quantity, 1)
    }

    func testTotalIncreasesAfterIncrement() {
        cartVM.addProduct(realProduct())
        let totalBefore = cartVM.total
        let item = cartVM.items.first!
        cartVM.increment(item: item)
        XCTAssertGreaterThan(cartVM.total, totalBefore)
    }

    // MARK: - Удаление

    func testRemoveItemDeletesItFromCart() {
        cartVM.addProduct(realProduct())
        let item = cartVM.items.first!
        cartVM.remove(item: item)
        XCTAssertTrue(cartVM.items.isEmpty)
    }

    func testRemoveOneOfTwoItemsLeavesOnlyOther() {
        cartVM.addProduct(realProduct(id: 1))
        cartVM.addProduct(realProduct(id: 2))
        let first = cartVM.items.first!
        cartVM.remove(item: first)
        XCTAssertEqual(cartVM.items.count, 1)
    }

    func testTotalBecomesZeroAfterRemovingAllItems() {
        cartVM.addProduct(realProduct())
        let item = cartVM.items.first!
        cartVM.remove(item: item)
        XCTAssertEqual(cartVM.total, 0.0)
    }

    // MARK: - Checkout

    func testPlaceOrderCreatesOrder() {
        cartVM.addProduct(realProduct())
        cartVM.placeOrder()
        XCTAssertNotNil(cartVM.placedOrder)
    }

    func testPlaceOrderClearsCart() {
        cartVM.addProduct(realProduct())
        cartVM.placeOrder()
        XCTAssertTrue(cartVM.items.isEmpty)
    }

    func testPlaceOrderTotalMatchesCartTotal() {
        cartVM.addProduct(realProduct())
        let expectedTotal = cartVM.total
        cartVM.placeOrder()
        XCTAssertEqual(cartVM.placedOrder?.totalPrice ?? 0, expectedTotal, accuracy: 0.01)
    }

    func testFormattedTotalContainsDollarSign() {
        cartVM.addProduct(realProduct())
        XCTAssertTrue(cartVM.formattedTotal.contains("$"))
    }

    // MARK: - Helper
    // Используем продукт который реально есть в seed-данных БД
    private func realProduct(id: Int = 1) -> Product {
        Product(
            id: id,
            categoryId: 1,
            title: "Test Product",
            description: "",
            price: 14.99,
            stock: 10,
            imageUrl: nil
        )
    }
}
