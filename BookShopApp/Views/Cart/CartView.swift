//
//  CartView.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var viewModel: CartViewModel
    @State private var showConfirmation = false
    @State private var showOrders = false
    @State private var showCheckout = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.items.isEmpty {
                    emptyState
                } else {
                    cartContent
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.loadOrders()
                        showOrders = true
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                    .foregroundStyle(Color.accent)
                }
            }
            .onAppear { viewModel.loadCart() }
            .navigationDestination(isPresented: $showOrders) {
                OrdersListView(viewModel: viewModel)
            }
            .sheet(isPresented: $showConfirmation) {
                if let order = viewModel.placedOrder {
                    OrderConfirmationView(order: order) {
                        showConfirmation = false
                        viewModel.placedOrder = nil
                    }
                }
            }
            .onChange(of: viewModel.placedOrder) { _, new in
                if new != nil { showConfirmation = true }
            }
            .sheet(isPresented: $showCheckout, onDismiss: {   // ← вот он
                viewModel.loadCart()
            }) {
                CheckoutView(items: viewModel.items)
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "cart")
                .font(.system(size: 64))
                .foregroundStyle(Color.accent.opacity(0.3))
            VStack(spacing: 8) {
                Text("Your cart is empty")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color(hex: "1E1B4B"))
                Text("Add books and stationery\nfrom the catalog")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
    }

    // MARK: - Cart Content

    private var cartContent: some View {
        VStack(spacing: 0) {
            List {
                Section {
                    ForEach(viewModel.items) { item in
                        CartItemRow(
                            item: item,
                            onIncrement: { viewModel.increment(item: item) },
                            onDecrement: { viewModel.decrement(item: item) },
                            onRemove:    { viewModel.remove(item: item) }
                        )
                    }
                }
                Section {
                    HStack {
                        Text("Total")
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                        Text(viewModel.formattedTotal)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color.accent)
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.insetGrouped)

            VStack(spacing: 0) {
                Divider()
                PrimaryButton(title: "Checkout — \(viewModel.formattedTotal)") {
                    showCheckout = true
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(.systemBackground))
            }
        }
    }
}

#Preview("Cart Light") {
    CartView(viewModel: CartViewModel())
        .environmentObject(SessionService.shared)
}

#Preview("Cart Dark") {
    CartView(viewModel: CartViewModel())
        .environmentObject(SessionService.shared)
        .preferredColorScheme(.dark)
}
