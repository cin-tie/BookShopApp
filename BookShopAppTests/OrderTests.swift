// OrderTests.swift
// BookShopAppTests — Unit Tests

import XCTest
@testable import BookShopApp

// MARK: - Order Model

final class OrderModelTests: XCTestCase {

    func testOrderFormattedTotalNotEmpty() {
        let order = Order(id: 1, userId: 1, status: .pending, totalPrice: 29.99, createdAt: Date(), items: [])
        XCTAssertFalse(order.formattedTotal.isEmpty)
    }

    func testOrderFormattedDateNotEmpty() {
        let order = Order(id: 1, userId: 1, status: .pending, totalPrice: 10, createdAt: Date(), items: [])
        XCTAssertFalse(order.formattedDate.isEmpty)
    }

    func testOrderStatusDisplayNames() {
        XCTAssertEqual(OrderStatus.pending.displayName,   "Pending")
        XCTAssertEqual(OrderStatus.confirmed.displayName, "Confirmed")
        XCTAssertEqual(OrderStatus.cancelled.displayName, "Cancelled")
    }

    func testOrderStatusRawValues() {
        XCTAssertEqual(OrderStatus.pending.rawValue,   "pending")
        XCTAssertEqual(OrderStatus.confirmed.rawValue, "confirmed")
        XCTAssertEqual(OrderStatus.cancelled.rawValue, "cancelled")
    }

    func testOrderStatusColorsNotEmpty() {
        XCTAssertFalse(OrderStatus.pending.color.isEmpty)
        XCTAssertFalse(OrderStatus.confirmed.color.isEmpty)
        XCTAssertFalse(OrderStatus.cancelled.color.isEmpty)
    }
}

// MARK: - OrderRepository

@MainActor
final class OrderRepositoryTests: XCTestCase {

    let session = SessionService.shared
    let orderRepo = OrderRepository.shared
    var userId: Int { session.stableUserId() }

    override func setUp() {
        super.setUp()
        session.logout()
        UserDefaults.standard.removeObject(forKey: "all_users")
        UserDefaults.standard.removeObject(forKey: "session_user")
        _ = session.register(
            name: "Order User",
            email: "order_\(UUID().uuidString.prefix(6))@test.com",
            password: "pass1234",
            confirm: "pass1234"
        )
    }

    override func tearDown() {
        session.logout()
        UserDefaults.standard.removeObject(forKey: "all_users")
        UserDefaults.standard.removeObject(forKey: "session_user")
        super.tearDown()
    }

    func testCreateOrderReturnsNonNil() {
        let order = orderRepo.createOrder(userId: userId, items: fakeItems(), total: 19.98)
        XCTAssertNotNil(order)
    }

    func testCreatedOrderHasPendingStatus() {
        let order = orderRepo.createOrder(userId: userId, items: fakeItems(), total: 10.0)
        XCTAssertEqual(order?.status, .pending)
    }

    func testCreatedOrderHasCorrectTotal() {
        let order = orderRepo.createOrder(userId: userId, items: fakeItems(), total: 42.0)
        XCTAssertEqual(order?.totalPrice ?? 0, 42.0, accuracy: 0.001)
    }

    func testCreatedOrderAppearsInFetch() {
        _ = orderRepo.createOrder(userId: userId, items: fakeItems(), total: 10.0)
        let orders = orderRepo.fetchOrders(userId: userId)
        XCTAssertFalse(orders.isEmpty)
    }

    func testCancelPendingOrderChangesStatus() {
        guard let order = orderRepo.createOrder(userId: userId, items: fakeItems(), total: 10.0) else {
            XCTFail("Order not created"); return
        }
        orderRepo.cancelOrder(id: order.id)
        let updated = orderRepo.fetchOrders(userId: userId).first { $0.id == order.id }
        XCTAssertEqual(updated?.status, .cancelled)
    }

    func testConfirmOrderChangesStatus() {
        guard let order = orderRepo.createOrder(userId: userId, items: fakeItems(), total: 10.0) else { return }
        orderRepo.confirmOrder(id: order.id)
        let updated = orderRepo.fetchOrders(userId: userId).first { $0.id == order.id }
        XCTAssertEqual(updated?.status, .confirmed)
    }

    func testFetchOrdersReturnsOrdersForCorrectUser() {
        _ = orderRepo.createOrder(userId: userId, items: fakeItems(), total: 10.0)
        let orders = orderRepo.fetchOrders(userId: userId)
        // Все заказы принадлежат текущему userId
        XCTAssertTrue(orders.allSatisfy { $0.userId == userId })
    }

    private func fakeItems() -> [CartItem] {
        [CartItem(
            id: 1, cartId: 1,
            product: Product(id: 1, categoryId: 1, title: "Book", description: "", price: 14.99, stock: 5, imageUrl: nil),
            quantity: 1
        )]
    }
}
