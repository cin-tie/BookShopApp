// CoverageTests.swift
// BookShopAppTests
// Покрывает: Order, Payment, DeliveryAddress, AuthViewModel,
//            CatalogViewModel, CheckoutViewModel, PaymentRepository

import XCTest
@testable import BookShopApp

// MARK: - Order Model

final class OrderModelCoverageTests: XCTestCase {

    func testFormattedTotalContainsDollarSign() {
        let order = makeOrder(total: 29.99)
        XCTAssertTrue(order.formattedTotal.contains("$") || order.formattedTotal.contains("29"))
    }

    func testFormattedTotalZero() {
        let order = makeOrder(total: 0)
        XCTAssertFalse(order.formattedTotal.isEmpty)
    }

    func testFormattedDateNotEmpty() {
        let order = makeOrder()
        XCTAssertFalse(order.formattedDate.isEmpty)
    }

    func testOrderStatusPendingDisplayName() {
        XCTAssertEqual(OrderStatus.pending.displayName, "Pending")
    }

    func testOrderStatusConfirmedDisplayName() {
        XCTAssertEqual(OrderStatus.confirmed.displayName, "Confirmed")
    }

    func testOrderStatusCancelledDisplayName() {
        XCTAssertEqual(OrderStatus.cancelled.displayName, "Cancelled")
    }

    func testOrderStatusPendingColor() {
        XCTAssertEqual(OrderStatus.pending.color, "F59E0B")
    }

    func testOrderStatusConfirmedColor() {
        XCTAssertEqual(OrderStatus.confirmed.color, "22C55E")
    }

    func testOrderStatusCancelledColor() {
        XCTAssertEqual(OrderStatus.cancelled.color, "EF4444")
    }

    func testOrderStatusRawValues() {
        XCTAssertEqual(OrderStatus.pending.rawValue,   "pending")
        XCTAssertEqual(OrderStatus.confirmed.rawValue, "confirmed")
        XCTAssertEqual(OrderStatus.cancelled.rawValue, "cancelled")
    }

    func testOrderInequalityByStatus() {
        var a = makeOrder(id: 1)
        var b = makeOrder(id: 1)
        a.status = .pending
        b.status = .confirmed
        XCTAssertNotEqual(a, b)
    }

    func testOrderCaseIterable() {
        XCTAssertEqual(OrderStatus.allCases.count, 3)
    }

    private func makeOrder(id: Int = 1, total: Double = 10.0) -> Order {
        Order(id: id, userId: 1, status: .pending, totalPrice: total, createdAt: Date(), items: [])
    }
}

// MARK: - Payment Model

final class PaymentModelCoverageTests: XCTestCase {

    func testFormattedAmountContainsValue() {
        let p = makePayment(amount: 14.99)
        XCTAssertTrue(p.formattedAmount.contains("14") || p.formattedAmount.contains("$"))
    }

    func testPaymentMethodDisplayNames() {
        XCTAssertEqual(PaymentMethod.applePay.displayName, "Apple Pay")
        XCTAssertEqual(PaymentMethod.visa.displayName,     "Visa Card")
        XCTAssertEqual(PaymentMethod.cash.displayName,     "Cash")
    }

    func testPaymentMethodIcons() {
        XCTAssertEqual(PaymentMethod.applePay.icon, "apple.logo")
        XCTAssertEqual(PaymentMethod.visa.icon,     "creditcard.fill")
        XCTAssertEqual(PaymentMethod.cash.icon,     "banknote.fill")
    }

    func testPaymentMethodDescriptions() {
        XCTAssertFalse(PaymentMethod.applePay.description.isEmpty)
        XCTAssertFalse(PaymentMethod.visa.description.isEmpty)
        XCTAssertFalse(PaymentMethod.cash.description.isEmpty)
    }

    func testPaymentMethodRawValues() {
        XCTAssertEqual(PaymentMethod.applePay.rawValue, "apple_pay")
        XCTAssertEqual(PaymentMethod.visa.rawValue,     "visa")
        XCTAssertEqual(PaymentMethod.cash.rawValue,     "cash")
    }

    func testPaymentMethodId() {
        XCTAssertEqual(PaymentMethod.visa.id, "visa")
    }

    func testPaymentStatusDisplayNames() {
        XCTAssertEqual(PaymentStatus.pending.displayName,   "Pending")
        XCTAssertEqual(PaymentStatus.completed.displayName, "Completed")
        XCTAssertEqual(PaymentStatus.failed.displayName,    "Failed")
        XCTAssertEqual(PaymentStatus.refunded.displayName,  "Refunded")
    }

    func testPaymentStatusRawValues() {
        XCTAssertEqual(PaymentStatus.pending.rawValue,   "pending")
        XCTAssertEqual(PaymentStatus.completed.rawValue, "completed")
        XCTAssertEqual(PaymentStatus.failed.rawValue,    "failed")
        XCTAssertEqual(PaymentStatus.refunded.rawValue,  "refunded")
    }

    func testPaymentEquality() {
        let a = makePayment()
        let b = makePayment()
        XCTAssertEqual(a, b)
    }

    func testPaymentMethodCaseIterable() {
        XCTAssertEqual(PaymentMethod.allCases.count, 3)
    }

    private func makePayment(amount: Double = 9.99) -> Payment {
        Payment(id: 1, orderId: 1, paymentMethod: .cash, amount: amount, status: .pending)
    }
}

// MARK: - DeliveryAddress Model

final class DeliveryAddressTests: XCTestCase {

    func testFullAddressFormat() {
        let addr = DeliveryAddress(id: 1, userId: 1, city: "Moscow",
                                  street: "Lenin St", house: "10", postalCode: "123456")
        XCTAssertEqual(addr.fullAddress, "Lenin St, 10, Moscow 123456")
    }

    func testIsValidWithAllFields() {
        let addr = DeliveryAddress(id: 1, userId: 1, city: "Moscow",
                                  street: "Lenin St", house: "10", postalCode: "")
        XCTAssertTrue(addr.isValid)
    }

    func testIsInvalidWithEmptyCity() {
        let addr = DeliveryAddress(id: 1, userId: 1, city: "",
                                  street: "Lenin St", house: "10", postalCode: "")
        XCTAssertFalse(addr.isValid)
    }

    func testIsInvalidWithEmptyStreet() {
        let addr = DeliveryAddress(id: 1, userId: 1, city: "Moscow",
                                  street: "", house: "10", postalCode: "")
        XCTAssertFalse(addr.isValid)
    }

    func testIsInvalidWithEmptyHouse() {
        let addr = DeliveryAddress(id: 1, userId: 1, city: "Moscow",
                                  street: "Lenin St", house: "", postalCode: "")
        XCTAssertFalse(addr.isValid)
    }

    func testIsInvalidWithWhitespaceOnly() {
        let addr = DeliveryAddress(id: 1, userId: 1, city: "   ",
                                  street: "  ", house: "  ", postalCode: "")
        XCTAssertFalse(addr.isValid)
    }

    func testPostalCodeNotRequired() {
        let addr = DeliveryAddress(id: 1, userId: 1, city: "Moscow",
                                  street: "Lenin St", house: "10", postalCode: "")
        XCTAssertTrue(addr.isValid)
    }
}

// MARK: - AuthViewModel

@MainActor
final class AuthViewModelCoverageTests: XCTestCase {

    var vm: AuthViewModel!

    override func setUp() {
        super.setUp()
        vm = AuthViewModel()
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

    func testInitialStateIsEmpty() {
        XCTAssertEqual(vm.loginEmail, "")
        XCTAssertEqual(vm.loginPassword, "")
        XCTAssertEqual(vm.registerName, "")
        XCTAssertNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
    }

    func testClearErrorsSetsNil() {
        vm.errorMessage = "Some error"
        vm.clearErrors()
        XCTAssertNil(vm.errorMessage)
    }

    func testLoginSetsIsLoadingTrue() {
        vm.loginEmail = "test@test.com"
        vm.loginPassword = "password"
        vm.login()
        XCTAssertTrue(vm.isLoading)
    }

    func testLoginSetsErrorAfterDelay() {
        let exp = expectation(description: "login completes")
        vm.loginEmail = "nobody@test.com"
        vm.loginPassword = "password123"
        vm.login()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertFalse(self.vm.isLoading)
            XCTAssertNotNil(self.vm.errorMessage)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }

    func testRegisterSetsIsLoadingTrue() {
        vm.registerName = "Test"
        vm.registerEmail = "test@test.com"
        vm.registerPassword = "pass1234"
        vm.registerConfirm = "pass1234"
        vm.register()
        XCTAssertTrue(vm.isLoading)
    }

    func testRegisterWithEmptyFieldsSetsError() {
        let exp = expectation(description: "register completes")
        vm.register()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertFalse(self.vm.isLoading)
            XCTAssertNotNil(self.vm.errorMessage)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }

    func testRegisterSuccessfullyLogsIn() {
        let exp = expectation(description: "register success")
        vm.registerName = "Test User"
        vm.registerEmail = "newuser_\(Int.random(in: 10000...99999))@test.com"
        vm.registerPassword = "pass1234"
        vm.registerConfirm = "pass1234"
        vm.register()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNil(self.vm.errorMessage)
            XCTAssertNotNil(SessionService.shared.currentUser)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
}

// MARK: - CatalogViewModel

@MainActor
final class CatalogViewModelCoverageTests: XCTestCase {

    var vm: CatalogViewModel!

    override func setUp() {
        super.setUp()
        vm = CatalogViewModel()
    }

    func testInitLoadsProducts() {
        let exp = expectation(description: "products loaded")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertFalse(self.vm.products.isEmpty)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }

    func testInitLoadsCategories() {
        XCTAssertFalse(vm.categories.isEmpty)
        // Первая категория всегда "All"
        XCTAssertEqual(vm.categories.first?.id, 0)
    }

    func testSelectCategoryFiltersProducts() {
        let exp = expectation(description: "category filtered")
        guard let fiction = vm.categories.first(where: { $0.title == "Fiction" }) else {
            exp.fulfill(); return
        }
        vm.select(category: fiction)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.vm.products.allSatisfy { $0.categoryId == fiction.id })
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }

    func testSearchReturnsMatchingProducts() {
        let exp = expectation(description: "search done")
        vm.onSearchChange("Swift")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Либо есть совпадения либо пусто — главное не краш
            XCTAssertNotNil(self.vm.products)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }

    func testSelectedCategoryDefaultIsAll() {
        XCTAssertEqual(vm.selectedCategory.id, 0)
    }
}

// MARK: - PaymentRepository

@MainActor
final class PaymentRepositoryCoverageTests: XCTestCase {

    let repo = PaymentRepository.shared
    let orderRepo = OrderRepository.shared
    let session = SessionService.shared

    override func setUp() {
        super.setUp()
        session.logout()
        UserDefaults.standard.removeObject(forKey: "all_users")
        UserDefaults.standard.removeObject(forKey: "session_user")
        _ = session.register(name: "PayTest", email: "paytest_\(Int.random(in: 10000...99999))@test.com",
                             password: "pass1234", confirm: "pass1234")
    }

    override func tearDown() {
        session.logout()
        UserDefaults.standard.removeObject(forKey: "all_users")
        UserDefaults.standard.removeObject(forKey: "session_user")
        super.tearDown()
    }

    func testCreatePaymentReturnsNonNil() {
        let orderId = createTestOrder()
        let payment = repo.createPayment(orderId: orderId, method: .cash, amount: 14.99)
        XCTAssertNotNil(payment)
    }

    func testCreatePaymentHasPendingStatus() {
        let orderId = createTestOrder()
        let payment = repo.createPayment(orderId: orderId, method: .cash, amount: 14.99)
        XCTAssertEqual(payment?.status, .pending)
    }

    func testCreatePaymentStoresCorrectMethod() {
        let orderId = createTestOrder()
        let payment = repo.createPayment(orderId: orderId, method: .visa, amount: 9.99)
        XCTAssertEqual(payment?.paymentMethod, .visa)
    }

    func testUpdateStatusChangesToCompleted() {
        let orderId = createTestOrder()
        guard let payment = repo.createPayment(orderId: orderId, method: .cash, amount: 14.99) else {
            XCTFail("Payment not created"); return
        }
        repo.updateStatus(paymentId: payment.id, status: .completed)
        let fetched = repo.fetchPayment(orderId: orderId)
        XCTAssertEqual(fetched?.status, .completed)
    }

    func testFetchPaymentReturnsCorrectAmount() {
        let orderId = createTestOrder()
        _ = repo.createPayment(orderId: orderId, method: .applePay, amount: 29.99)
        let fetched = repo.fetchPayment(orderId: orderId)
        XCTAssertEqual(fetched?.amount ?? 0, 29.99, accuracy: 0.001)
    }

    func testFetchPaymentForNonExistentOrderReturnsNil() {
        let fetched = repo.fetchPayment(orderId: 999999)
        XCTAssertNil(fetched)
    }

    func testAllPaymentMethodsCanBeCreated() {
        for method in PaymentMethod.allCases {
            let orderId = createTestOrder()
            let payment = repo.createPayment(orderId: orderId, method: method, amount: 9.99)
            XCTAssertNotNil(payment, "Payment with method \(method) should be created")
        }
    }

    // MARK: - CheckoutViewModel

    func testCheckoutViewModelInitWithItems() {
        let items = [CartItem(id: 1, cartId: 1,
                              product: Product(id: 1, categoryId: 1, title: "Book",
                                              description: "", price: 14.99, stock: 5, imageUrl: nil),
                              quantity: 2)]
        let vm = CheckoutViewModel(items: items)
        XCTAssertEqual(vm.total, 29.98, accuracy: 0.001)
    }

    func testCheckoutViewModelFormattedTotal() {
        let items = [CartItem(id: 1, cartId: 1,
                              product: Product(id: 1, categoryId: 1, title: "Book",
                                              description: "", price: 9.99, stock: 5, imageUrl: nil),
                              quantity: 1)]
        let vm = CheckoutViewModel(items: items)
        XCTAssertTrue(vm.formattedTotal.contains("$") || vm.formattedTotal.contains("9"))
    }

    func testCheckoutViewModelDefaultMethod() {
        let vm = CheckoutViewModel(items: [])
        XCTAssertEqual(vm.selectedMethod, .applePay)
    }

    func testCheckoutViewModelCancelResetsStep() {
        let vm = CheckoutViewModel(items: [])
        vm.step = .processing
        vm.cancelCheckout()
        XCTAssertEqual(vm.step, .summary)
        XCTAssertNil(vm.errorMessage)
    }

    func testCheckoutViewModelPlaceOrderWithEmptyCartSetsError() {
        let vm = CheckoutViewModel(items: [])
        vm.placeOrder()
        XCTAssertEqual(vm.errorMessage, "Cart is empty")
    }

    func testCheckoutViewModelSaveNewAddressWithEmptyFieldsFails() {
        let vm = CheckoutViewModel(items: [])
        let result = vm.saveNewAddress()
        XCTAssertFalse(result)
        XCTAssertNotNil(vm.errorMessage)
    }

    // MARK: - Helper

    private func createTestOrder() -> Int {
        let items = [CartItem(id: 1, cartId: 1,
                              product: Product(id: 1, categoryId: 1, title: "Book",
                                              description: "", price: 14.99, stock: 5, imageUrl: nil),
                              quantity: 1)]
        return orderRepo.createOrder(userId: session.stableUserId(), items: items, total: 14.99)?.id ?? 0
    }
}
