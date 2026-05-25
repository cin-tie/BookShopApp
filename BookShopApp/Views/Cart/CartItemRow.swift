//
//  CartItemRow.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import SwiftUI

struct CartItemRow: View {
    let item: CartItem
    var onIncrement: () -> Void
    var onDecrement: () -> Void
    var onRemove: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            // Thumbnail
            AsyncImage(url: URL(string: item.product.imageUrl ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    ZStack {
                        Color(.systemGray5)
                        Image(systemName: "book.closed.fill")
                            .foregroundStyle(Color.accent.opacity(0.4))
                    }
                }
            }
            .frame(width: 64, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            // Info
            VStack(alignment: .leading, spacing: 6) {
                Text(item.product.title)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(2)

                Text(item.formattedSubtotal)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.accent)
            }

            Spacer()

            // Stepper
            VStack(spacing: 8) {
                Button(action: onRemove) {
                    Image(systemName: "trash")
                        .font(.system(size: 12))
                        .foregroundStyle(.red.opacity(0.7))
                }
                .buttonStyle(.plain)          // ← ключевой фикс
                .accessibilityIdentifier("removeButton")

                HStack(spacing: 0) {
                    Button(action: onDecrement) {
                        Image(systemName: "minus")
                            .font(.system(size: 11, weight: .bold))
                            .frame(width: 28, height: 28)
                    }
                    .buttonStyle(.plain)      // ← ключевой фикс]
                    .accessibilityIdentifier("decrementButton")

                    Text("\(item.quantity)")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 28)
                        .accessibilityElement()
                        .accessibilityIdentifier("quantityLabel")

                    Button(action: onIncrement) {
                        Image(systemName: "plus")
                            .font(.system(size: 11, weight: .bold))
                            .frame(width: 28, height: 28)
                    }
                    .buttonStyle(.plain)      // ← ключевой фикс
                    .accessibilityIdentifier("incrementButton")
                }
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .foregroundStyle(Color(.label))
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())            // ← делаем явную hit-область
        .accessibilityElement(children: .contain)
        .accessibilityElement()
        .accessibilityIdentifier("cartItemRow")
    }
}
