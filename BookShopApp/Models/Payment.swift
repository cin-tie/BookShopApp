//
//  Payment.swift
//  BookShopApp
//
//  Created by Maria Shulga on 21/05/2026.
//

import Foundation

struct Payment: Identifiable, Equatable {
    let id: Int
    let orderId: Int
    let paymentMethod: PaymentMethod
    let amount: Double
    var status: PaymentStatus

    var formattedAmount: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        return f.string(from: NSNumber(value: amount)) ?? "$\(amount)"
    }
}

enum PaymentMethod: String, CaseIterable, Identifiable {
    case applePay  = "apple_pay"
    case visa      = "visa"
    case cash      = "cash"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .applePay: return "Apple Pay"
        case .visa:     return "Visa Card"
        case .cash:     return "Cash"
        }
    }

    var icon: String {
        switch self {
        case .applePay: return "apple.logo"
        case .visa:     return "creditcard.fill"
        case .cash:     return "banknote.fill"
        }
    }

    var description: String {
        switch self {
        case .applePay: return "Pay with Face ID or Touch ID"
        case .visa:     return "Pay with your Visa card"
        case .cash:     return "Pay on pickup"
        }
    }
}

enum PaymentStatus: String, Codable {
    case pending   = "pending"
    case completed = "completed"
    case failed    = "failed"
    case refunded  = "refunded"

    var displayName: String {
        switch self {
        case .pending:   return "Pending"
        case .completed: return "Completed"
        case .failed:    return "Failed"
        case .refunded:  return "Refunded"
        }
    }
}
