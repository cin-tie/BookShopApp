//
//  Category.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import Foundation

struct Category: Identifiable, Equatable, Codable {
    let id: Int
    let title: String
    let icon: String          // SF Symbol name

    static let all = Category(id: 0, title: "All", icon: "square.grid.2x2")
}
