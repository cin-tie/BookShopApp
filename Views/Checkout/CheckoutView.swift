//
//  CheckoutView.swift
//  BookShopApp
//
//  Created by Maria Shulga on 21/05/2026.
//

import SwiftUI

import SwiftUI

struct CheckoutView: View {
    @StateObject private var viewModel: CheckoutViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showPaymentSheet  = false
    @State private var showAddressSheet  = false

    init(items: [CartItem]) {
        _viewModel = StateObject(wrappedValue: CheckoutViewModel(items: items))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.step {
                case .summary:   summaryView
                case .processing: processingView
                case .success:   successView
                case .failed:    failedView
                }
            }
            .navigationTitle(viewModel.step == .summary ? "Checkout" : "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if viewModel.step == .summary {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") { dismiss() }
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .interactiveDismissDisabled(viewModel.step == .processing)
        .sheet(isPresented: $showPaymentSheet) {
            PaymentMethodSheet(selected: $viewModel.selectedMethod)
        }
        .sheet(isPresented: $showAddressSheet) {
            DeliveryAddressSheet(viewModel: viewModel)
        }
    }

    // MARK: - Summary

    private var summaryView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Order items
                orderItemsSection

                // Payment method
                sectionCard(title: "Payment Method") {
                    Button { showPaymentSheet = true } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accent.opacity(0.12))
                                    .frame(width: 40, height: 40)
                                Image(systemName: viewModel.selectedMethod.icon)
                                    .foregroundStyle(Color.accent)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(viewModel.selectedMethod.displayName)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(Color(.label))
                                Text(viewModel.selectedMethod.description)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }

                // Delivery address
                sectionCard(title: "Delivery Address") {
                    Button { showAddressSheet = true } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: "22C55E").opacity(0.12))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundStyle(Color(hex: "22C55E"))
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                if let address = viewModel.selectedAddress {
                                    Text(address.fullAddress)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(Color(.label))
                                        .lineLimit(2)
                                } else {
                                    Text("Add delivery address")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }

                // Total
                sectionCard(title: "Order Total") {
                    HStack {
                        Text("\(viewModel.items.count) item\(viewModel.items.count == 1 ? "" : "s")")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(viewModel.formattedTotal)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color.accent)
                    }
                }

                // Actions
                VStack(spacing: 12) {
                    PrimaryButton(title: "Pay \(viewModel.formattedTotal)") {
                        viewModel.placeOrder()
                    }
                    PrimaryButton(title: "Cancel", style: .outlined) {
                        dismiss()
                    }
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Processing

    private var processingView: some View {
        VStack(spacing: 28) {
            Spacer()
            ProgressView()
                .scaleEffect(1.6)
                .tint(Color.accent)

            VStack(spacing: 8) {
                Text("Processing Payment")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                Text("Please wait...")
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }

    // MARK: - Success

    private var successView: some View {
        PaymentConfirmationView(
            order: viewModel.placedOrder,
            payment: viewModel.payment,
            onDone: { dismiss() }
        )
    }

    // MARK: - Failed

    private var failedView: some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                Circle().fill(Color.red.opacity(0.1)).frame(width: 100, height: 100)
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(.red)
            }
            VStack(spacing: 8) {
                Text("Payment Failed")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Text(viewModel.errorMessage ?? "Something went wrong. Please try again.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            Spacer()
            VStack(spacing: 12) {
                PrimaryButton(title: "Try Again") { viewModel.cancelCheckout() }
                PrimaryButton(title: "Cancel", style: .outlined) { dismiss() }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Helpers

    private var orderItemsSection: some View {
        sectionCard(title: "Items") {
            VStack(spacing: 0) {
                ForEach(viewModel.items) { item in
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: item.product.imageUrl ?? "")) { phase in
                            switch phase {
                            case .success(let image): image.resizable().scaledToFill()
                            default:
                                ZStack {
                                    Color(.systemGray5)
                                    Image(systemName: "book.closed.fill")
                                        .foregroundStyle(Color.accent.opacity(0.4))
                                }
                            }
                        }
                        .frame(width: 48, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading, spacing: 3) {
                            Text(item.product.title)
                                .font(.system(size: 13, weight: .medium))
                                .lineLimit(2)
                            Text("×\(item.quantity)")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(item.formattedSubtotal)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.accent)
                    }
                    .padding(.vertical, 8)

                    if item.id != viewModel.items.last?.id {
                        Divider()
                    }
                }
            }
        }
    }

    private func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .tracking(0.5)
            content()
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview("Checkout Light") {
    CheckoutView(items: [
        CartItem(id: 1, cartId: 1,
                 product: Product(id: 1, categoryId: 1, title: "The Midnight Library",
                                  description: "A novel.", price: 14.99, stock: 5,
                                  imageUrl: nil),
                 quantity: 2),
        CartItem(id: 2, cartId: 1,
                 product: Product(id: 2, categoryId: 2, title: "Atomic Habits",
                                  description: "Tiny changes.", price: 17.99, stock: 10,
                                  imageUrl: nil),
                 quantity: 1)
    ])
}

#Preview("Checkout Dark") {
    CheckoutView(items: [
        CartItem(id: 1, cartId: 1,
                 product: Product(id: 1, categoryId: 1, title: "The Midnight Library",
                                  description: "A novel.", price: 14.99, stock: 5,
                                  imageUrl: nil),
                 quantity: 1)
    ])
    .preferredColorScheme(.dark)
}
