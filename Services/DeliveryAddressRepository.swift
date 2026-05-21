//
//  DeliveryAddressRepository.swift
//  BookShopApp
//
//  Created by Maria Shulga on 21/05/2026.
//

import Foundation
import SQLite3

final class DeliveryAddressRepository {
    static let shared = DeliveryAddressRepository()
    private let db = DatabaseService.shared

    private init() {}

    func fetchAddresses(userId: Int) -> [DeliveryAddress] {
        var result: [DeliveryAddress] = []
        var stmt: OpaquePointer?
        let q = "SELECT id, userId, city, street, house, postalCode FROM delivery_addresses WHERE userId = \(userId);"
        if sqlite3_prepare_v2(db.database, q, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let id         = Int(sqlite3_column_int(stmt, 0))
                let uId        = Int(sqlite3_column_int(stmt, 1))
                let city       = String(cString: sqlite3_column_text(stmt, 2))
                let street     = String(cString: sqlite3_column_text(stmt, 3))
                let house      = String(cString: sqlite3_column_text(stmt, 4))
                let postalCode = String(cString: sqlite3_column_text(stmt, 5))
                result.append(DeliveryAddress(id: id, userId: uId,
                    city: city, street: street, house: house, postalCode: postalCode))
            }
        }
        sqlite3_finalize(stmt)
        return result
    }

    func saveAddress(_ address: DeliveryAddress) -> DeliveryAddress? {
        let database = db.database
        let city    = address.city.replacingOccurrences(of: "'", with: "''")
        let street  = address.street.replacingOccurrences(of: "'", with: "''")
        let house   = address.house.replacingOccurrences(of: "'", with: "''")
        let postal  = address.postalCode.replacingOccurrences(of: "'", with: "''")

        if address.id == 0 {
            let sql = """
                INSERT INTO delivery_addresses (userId, city, street, house, postalCode)
                VALUES (\(address.userId), '\(city)', '\(street)', '\(house)', '\(postal)');
            """
            guard sqlite3_exec(database, sql, nil, nil, nil) == SQLITE_OK else { return nil }
            let newId = Int(sqlite3_last_insert_rowid(database))
            return DeliveryAddress(id: newId, userId: address.userId,
                city: address.city, street: address.street,
                house: address.house, postalCode: address.postalCode)
        } else {
            sqlite3_exec(database, """
                UPDATE delivery_addresses
                SET city='\(city)', street='\(street)', house='\(house)', postalCode='\(postal)'
                WHERE id=\(address.id);
            """, nil, nil, nil)
            return address
        }
    }

    func deleteAddress(id: Int) {
        sqlite3_exec(db.database,
            "DELETE FROM delivery_addresses WHERE id = \(id);", nil, nil, nil)
    }
}
