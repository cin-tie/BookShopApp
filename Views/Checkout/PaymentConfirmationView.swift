//
//  PaymentConfirmationView.swift
//  BookShopApp
//
//  Created by Maria Shulga on 21/05/2026.
//

import SwiftUI

struct PaymentConfirmationView: View {
    let order: Order?
    let payment: Payment?
    var onDone: () -> Void

    @State private var appear = false

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            // Success icon
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

            VStack(spacing: 6) {
                Text("Payment Successful!")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: "1E1B4B"))

                if let order {
                    Text("Order #\(order.id)")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                }
            }
            .offset(y: appear ? 0 : 20)
            .opacity(appear ? 1 : 0)

            // Payment details card
            if let payment {
                VStack(spacing: 14) {
                    detailRow(label: "Method", value: payment.paymentMethod.displayName)
                    Divider()
                    detailRow(label: "Amount", value: payment.formattedAmount)
                    Divider()
                    detailRow(label: "Status", value: payment.status.displayName, valueColor: Color(hex: "22C55E"))
                }
                .padding(20)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)
                .opacity(appear ? 1 : 0)
            }

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

    private func detailRow(label: String, value: String, valueColor: Color = Color(.label)) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(valueColor)
        }
    }
}
