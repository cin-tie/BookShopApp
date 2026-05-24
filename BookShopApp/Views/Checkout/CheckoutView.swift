//
//  CheckoutView.swift
//  BookShopApp
//
//  Created by Maria Shulga on 21/05/2026.
//

import SwiftUI

struct CheckoutView: View {
    @StateObject private var viewModel: CheckoutViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showPaymentSheet  = false
    @State private var showAddressSheet  = false
    @State private var showPickupMap = false

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
        .sheet(isPresented: $showPickupMap) {
            PickupMapView { point in
                viewModel.selectedPickupPoint = point
            }
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

                // Delivery mode picker
                sectionCard(title: "Delivery Method") {
                    HStack(spacing: 0) {
                        deliveryModeButton(
                            title: "Pickup",
                            icon: "storefront.fill",
                            mode: .pickup
                        )
                        deliveryModeButton(
                            title: "Delivery",
                            icon: "box.truck.fill",
                            mode: .delivery
                        )
                    }
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Conditional section
                if viewModel.deliveryMode == .pickup {
                    sectionCard(title: "Pickup Point") {
                        Button { showPickupMap = true } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: "F59E0B").opacity(0.12))
                                        .frame(width: 40, height: 40)
                                    Image(systemName: "storefront.fill")
                                        .foregroundStyle(Color(hex: "F59E0B"))
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                    if let point = viewModel.selectedPickupPoint {
                                        Text(point.title)
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color(.label))
                                        Text(point.address)
                                            .font(.system(size: 12))
                                            .foregroundStyle(.secondary)
                                            .lineLimit(1)
                                    } else {
                                        Text("Select pickup point")
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
                } else {
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

                if let error = viewModel.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.circle.fill")
                        Text(error)
                            .font(.system(size: 14))
                    }
                    .foregroundStyle(.red)
                    .padding(12)
                    .background(Color.red.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
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
        .background(Color(.systemGroupedBackground))
        .animation(.easeInOut(duration: 0.2), value: viewModel.deliveryMode)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
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
        .shadow(color: .black.opacity(0.02), radius: 6, x: 0, y: 2)
    }
    
    private func deliveryModeButton(title: String, icon: String, mode: DeliveryMode) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.deliveryMode = mode
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                viewModel.deliveryMode == mode
                    ? Color(.systemBackground)
                    : Color.clear
            )
            .foregroundStyle(
                viewModel.deliveryMode == mode
                    ? Color.accent
                    : Color(.secondaryLabel)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(3)
            .shadow(
                color: viewModel.deliveryMode == mode ? .black.opacity(0.06) : .clear,
                radius: 4, y: 1
            )
        }
        .buttonStyle(.plain)
    }

}
