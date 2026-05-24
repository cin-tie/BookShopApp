//
//  User.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import Foundation

struct User: Codable, Equatable {
    let id: UUID
    var name: String
    var email: String
    var phone: String?

    init(id: UUID = UUID(), name: String, email: String, phone: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
    }
}
