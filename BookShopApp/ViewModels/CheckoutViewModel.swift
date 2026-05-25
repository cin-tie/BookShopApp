//
//  CheckoutViewModel.swift
//  BookShopApp
//
//  Created by Maria Shulga on 21/05/2026.
//

import Foundation

enum CheckoutStep {
    case summary, processing, success, failed
}

enum DeliveryMode {
    case pickup
    case delivery
}

@MainActor
final class CheckoutViewModel: ObservableObject {
    // MARK: - State
    @Published var selectedMethod: PaymentMethod = .applePay
    @Published var selectedAddress: DeliveryAddress?
    @Published var addresses: [DeliveryAddress] = []
    @Published var step: CheckoutStep = .summary
    @Published var placedOrder: Order?
    @Published var payment: Payment?
    @Published var errorMessage: String?
    @Published var selectedPickupPoint: PickupPoint?
    @Published var deliveryMode: DeliveryMode = .pickup

    // MARK: - New address form
    @Published var newCity     = ""
    @Published var newStreet   = ""
    @Published var newHouse    = ""
    @Published var newPostal   = ""

    private let paymentRepo = PaymentRepository.shared
    private let addressRepo = DeliveryAddressRepository.shared
    private let orderRepo   = OrderRepository.shared
    private let cartRepo    = CartRepository.shared
    private let session     = SessionService.shared

    private var userId: Int { session.stableUserId() }

    // MARK: - Init with cart items
    let items: [CartItem]
    var total: Double { items.reduce(0) { $0 + $1.subtotal } }
    var formattedTotal: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        return f.string(from: NSNumber(value: total)) ?? "$\(total)"
    }

    init(items: [CartItem]) {
        self.items = items
        loadAddresses()
    }

    // MARK: - Addresses

    func loadAddresses() {
        addresses = addressRepo.fetchAddresses(userId: userId)
        if selectedAddress == nil { selectedAddress = addresses.first }
    }

    func saveNewAddress() -> Bool {
        guard !newCity.trimmingCharacters(in: .whitespaces).isEmpty,
              !newStreet.trimmingCharacters(in: .whitespaces).isEmpty,
              !newHouse.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            errorMessage = "Please fill in city, street, and house"
            return false
        }
        let draft = DeliveryAddress(id: 0, userId: userId,
            city: newCity, street: newStreet,
            house: newHouse, postalCode: newPostal)
        if let saved = addressRepo.saveAddress(draft) {
            addresses.append(saved)
            selectedAddress = saved
            newCity = ""; newStreet = ""; newHouse = ""; newPostal = ""
            return true
        }
        return false
    }

    func deleteAddress(_ address: DeliveryAddress) {
        addressRepo.deleteAddress(id: address.id)
        addresses.removeAll { $0.id == address.id }
        if selectedAddress?.id == address.id {
            selectedAddress = addresses.first
        }
    }

    // MARK: - Checkout

    func placeOrder() {
        errorMessage = nil
            guard !items.isEmpty else {
                errorMessage = "Cart is empty"
                return
            }

            if deliveryMode == .pickup && selectedPickupPoint == nil {
                errorMessage = "Please select a pickup point"
                return
            }
            if deliveryMode == .delivery && selectedAddress == nil {
                errorMessage = "Please add a delivery address"
                return
            }


        step = .processing

        // Simulate payment processing delay
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)

            let order = orderRepo.createOrder(userId: userId, items: items, total: total)
            guard let order else {
                errorMessage = "Failed to create order"
                step = .failed
                return
            }

            let payment = paymentRepo.createPayment(
                orderId: order.id,
                method: selectedMethod,
                amount: total
            )
            guard let payment else {
                step = .failed
                return
            }

            // Simulate payment success (all methods succeed in demo)
            paymentRepo.updateStatus(paymentId: payment.id, status: .completed)

            // Update order status to confirmed
            orderRepo.confirmOrder(id: order.id)

            cartRepo.clearCart(userId: userId)

            self.placedOrder = order
            self.payment = Payment(id: payment.id, orderId: payment.orderId,
                                   paymentMethod: payment.paymentMethod,
                                   amount: payment.amount, status: .completed)
            step = .success
        }
    }

    func cancelCheckout() {
        step = .summary
        errorMessage = nil
    }
}
