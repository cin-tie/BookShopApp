//
//  DeliveryAddress.swift
//  BookShopApp
//
//  Created by Maria Shulga on 21/05/2026.
//

import Foundation

struct DeliveryAddress: Identifiable, Equatable, Codable {
    let id: Int
    let userId: Int
    var city: String
    var street: String
    var house: String
    var postalCode: String

    var fullAddress: String {
        "\(street), \(house), \(city) \(postalCode)"
    }

    var isValid: Bool {
        !city.trimmingCharacters(in: .whitespaces).isEmpty &&
        !street.trimmingCharacters(in: .whitespaces).isEmpty &&
        !house.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
