//
//  Product.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import Foundation

struct Product: Identifiable, Equatable, Codable {
    let id: Int
    let categoryId: Int
    var title: String
    var description: String
    var price: Double
    var stock: Int
    var imageUrl: String?

    var isAvailable: Bool { stock > 0 }

    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: price)) ?? "$\(price)"
    }
}
