//
//  OrderConformationView.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import SwiftUI

struct OrderConfirmationView: View {
    let order: Order
    var onDone: () -> Void

    @State private var appear = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Checkmark
            ZStack {
                Circle()
                    .fill(Color(hex: "22C55E").opacity(0.12))
                    .frame(width: 120, height: 120)
                Circle()
                    .fill(Color(hex: "22C55E"))
                    .frame(width: 88, height: 88)
                Image(systemName: "checkmark")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(.white)
            }
            .scaleEffect(appear ? 1 : 0.4)
            .opacity(appear ? 1 : 0)

            VStack(spacing: 8) {
                Text("Order Placed!")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: "1E1B4B"))

                Text("Order #\(order.id) • \(order.formattedTotal)")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
            }
            .offset(y: appear ? 0 : 20)
            .opacity(appear ? 1 : 0)

            // Items summary
            VStack(spacing: 0) {
                ForEach(order.items) { item in
                    HStack {
                        Text(item.product.title)
                            .font(.system(size: 14))
                            .lineLimit(1)
                        Spacer()
                        Text("×\(item.quantity)")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)

                    if item.id != order.items.last?.id {
                        Divider().padding(.horizontal, 16)
                    }
                }
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 24)
            .opacity(appear ? 1 : 0)

            Spacer()

            PrimaryButton(title: "Done", action: onDone)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .opacity(appear ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.1)) {
                appear = true
            }
        }
    }
}
