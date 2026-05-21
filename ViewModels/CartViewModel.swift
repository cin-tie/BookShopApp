//
//  CartViewModel.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import Foundation

@MainActor
final class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var orders: [Order] = []
    @Published var badgeCount: Int = 0
    @Published var placedOrder: Order?
    @Published var splitTargetOrder: Order?
    @Published var selectedItemsForSplit: Set<Int> = []

    private let cartRepo  = CartRepository.shared
    private let orderRepo = OrderRepository.shared
    private let session   = SessionService.shared

    private var userId: Int { session.numericUserId() }

    // MARK: - Cart

    func loadCart() {
        guard userId != 0 else { return }
        items = cartRepo.fetchCartItems(userId: userId)
        badgeCount = items.reduce(0) { $0 + $1.quantity }
    }

    func addProduct(_ product: Product) {
        guard userId != 0 else { return }
        cartRepo.addProduct(product.id, userId: userId)
        loadCart()
    }

    func remove(item: CartItem) {
        cartRepo.removeItem(itemId: item.id, userId: userId)
        loadCart()
    }

    func increment(item: CartItem) {
        cartRepo.updateQuantity(itemId: item.id, quantity: item.quantity + 1, userId: userId)
        loadCart()
    }

    func decrement(item: CartItem) {
        // Минимум 1 — убираем кнопкой trash, не декрементом
        guard item.quantity > 1 else { return }
        cartRepo.updateQuantity(itemId: item.id, quantity: item.quantity - 1, userId: userId)
        loadCart()
    }

    var total: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }

    var formattedTotal: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        return f.string(from: NSNumber(value: total)) ?? "$\(total)"
    }

    // MARK: - Checkout

    func placeOrder() {
        guard !items.isEmpty, userId != 0 else { return }
        let order = orderRepo.createOrder(userId: userId, items: items, total: total)
        cartRepo.clearCart(userId: userId)
        loadCart()
        loadOrders()
        placedOrder = order
    }

    // MARK: - Orders

    func loadOrders() {
        guard userId != 0 else { return }
        orders = orderRepo.fetchOrders(userId: userId)
    }

    func cancel(order: Order) {
        orderRepo.cancelOrder(id: order.id)
        loadOrders()
    }

    func beginSplit(order: Order) {
        splitTargetOrder = order
        selectedItemsForSplit = []
    }

    func confirmSplit() {
        guard let order = splitTargetOrder, !selectedItemsForSplit.isEmpty else { return }
        _ = orderRepo.splitOrder(id: order.id, itemIds: Array(selectedItemsForSplit))
        splitTargetOrder = nil
        selectedItemsForSplit = []
        loadOrders()
    }
}
