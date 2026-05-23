//
//  PickupPointCard.swift
//  BookShopApp
//
//  Created by Maria Shulga on 22/05/2026.
//

import SwiftUI

struct PickupPointCard: View {
    let point: PickupPoint
    let isSelected: Bool
    let distance: String?
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.accent : Color(.systemGray5))
                        .frame(width: 44, height: 44)
                    Image(systemName: "storefront.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(isSelected ? .white : Color(.secondaryLabel))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(point.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color(.label))
                    Text(point.address)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                if let distance {
                    Text(distance)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray6))
                        .clipShape(Capsule())
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(.tertiaryLabel))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemBackground))
                    .shadow(color: isSelected ? Color.accent.opacity(0.2) : .black.opacity(0.06),
                            radius: isSelected ? 8 : 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.accent : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: isSelected)
    }
}
