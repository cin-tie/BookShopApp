//
//  Order.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import Foundation

struct Order: Identifiable, Equatable {
    let id: Int
    let userId: Int
    var status: OrderStatus
    var totalPrice: Double
    let createdAt: Date
    var items: [OrderItem]

    var formattedTotal: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        return f.string(from: NSNumber(value: totalPrice)) ?? "$\(totalPrice)"
    }

    var formattedDate: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f.string(from: createdAt)
    }
}

enum OrderStatus: String, Codable, CaseIterable {
    case pending    = "pending"
    case confirmed  = "confirmed"
    case cancelled  = "cancelled"

    var displayName: String {
        switch self {
        case .pending:   return "Pending"
        case .confirmed: return "Confirmed"
        case .cancelled: return "Cancelled"
        }
    }

    var color: String {
        switch self {
        case .pending:   return "F59E0B"
        case .confirmed: return "22C55E"
        case .cancelled: return "EF4444"
        }
    }
}
