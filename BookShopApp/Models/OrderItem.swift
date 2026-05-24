//
//  OrderItem.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import Foundation

struct OrderItem: Identifiable, Equatable {
    let id: Int
    let orderId: Int
    let product: Product
    var quantity: Int
    var subtotal: Double
}
