//
//  PaymentMethodSheet.swift
//  BookShopApp
//
//  Created by Maria Shulga on 21/05/2026.
//

import SwiftUI

struct PaymentMethodSheet: View {
    @Binding var selected: PaymentMethod
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(PaymentMethod.allCases) { method in
                Button {
                    selected = method
                    dismiss()
                } label: {
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selected == method
                                      ? Color.accent
                                      : Color(.systemGray5))
                                .frame(width: 44, height: 44)
                            Image(systemName: method.icon)
                                .font(.system(size: 18))
                                .foregroundStyle(selected == method ? .white : Color(.label))
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text(method.displayName)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(Color(.label))
                            Text(method.description)
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        if selected == method {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.accent)
                        }
                    }
                    .padding(.vertical, 6)
                }
                .buttonStyle(.plain)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Payment Method")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accent)
                }
            }
        }
        .presentationDetents([.medium])
    }
}
