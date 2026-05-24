//
//  OrdersListView.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import SwiftUI

struct OrdersListView: View {
    @ObservedObject var viewModel: CartViewModel
    @State private var showSplitSheet = false

    var body: some View {
        Group {
            if viewModel.orders.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 44))
                        .foregroundStyle(Color.accent.opacity(0.4))
                    Text("No orders yet")
                        .font(.system(size: 17, weight: .semibold))
                    Text("Your order history will appear here")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.orders) { order in
                        OrderRow(order: order,
                                 onCancel: { viewModel.cancel(order: order) },
                                 onSplit: {
                                     viewModel.beginSplit(order: order)
                                     showSplitSheet = true
                                 })
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("My Orders")
        .navigationBarTitleDisplayMode(.large)
        .onAppear { viewModel.loadOrders() }
        .sheet(isPresented: $showSplitSheet) {
            if let order = viewModel.splitTargetOrder {
                SplitOrderSheet(order: order,
                                selected: $viewModel.selectedItemsForSplit,
                                onConfirm: {
                                    viewModel.confirmSplit()
                                    showSplitSheet = false
                                })
            }
        }
    }
}

// MARK: - Order Row

private struct OrderRow: View {
    let order: Order
    var onCancel: () -> Void
    var onSplit: () -> Void

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Order #\(order.id)")
                        .font(.system(size: 15, weight: .semibold))
                    Text(order.formattedDate)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Status badge
                Text(order.status.displayName)
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: order.status.color).opacity(0.15))
                    .foregroundStyle(Color(hex: order.status.color))
                    .clipShape(Capsule())
            }

            Text(order.formattedTotal)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.accent)

            // Expand items
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() }
            } label: {
                HStack {
                    Text("\(order.items.count) item\(order.items.count == 1 ? "" : "s")")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
            }

            if isExpanded {
                VStack(spacing: 6) {
                    ForEach(order.items) { item in
                        HStack {
                            Text(item.product.title)
                                .font(.system(size: 13))
                                .lineLimit(1)
                            Spacer()
                            Text("×\(item.quantity)")
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            // Actions
            if order.status == .pending {
                HStack(spacing: 10) {
                    Button(action: onCancel) {
                        Label("Cancel", systemImage: "xmark")
                            .font(.system(size: 13, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.red.opacity(0.1))
                            .foregroundStyle(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    if order.items.count > 1 {
                        Button(action: onSplit) {
                            Label("Split", systemImage: "arrow.branch")
                                .font(.system(size: 13, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Color.accent.opacity(0.1))
                                .foregroundStyle(Color.accent)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Split Sheet

private struct SplitOrderSheet: View {
    let order: Order
    @Binding var selected: Set<Int>
    var onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(order.items) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.product.title)
                            .font(.system(size: 14, weight: .medium))
                            .lineLimit(2)
                        Text("×\(item.quantity)")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    if selected.contains(item.id) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.accent)
                    } else {
                        Image(systemName: "circle")
                            .foregroundStyle(.secondary)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selected.contains(item.id) {
                        selected.remove(item.id)
                    } else {
                        selected.insert(item.id)
                    }
                }
            }
            .navigationTitle("Select Items to Split")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Split") { onConfirm() }
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accent)
                        .disabled(selected.isEmpty || selected.count == order.items.count)
                }
            }
        }
    }
}
