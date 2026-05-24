//
//  CartItem.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import Foundation

struct CartItem: Identifiable, Equatable {
    let id: Int
    let cartId: Int
    let product: Product
    var quantity: Int

    var subtotal: Double { product.price * Double(quantity) }

    var formattedSubtotal: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        return f.string(from: NSNumber(value: subtotal)) ?? "$\(subtotal)"
    }
}
