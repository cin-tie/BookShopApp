//
//  PickupPointRepository.swift
//  BookShopApp
//
//  Created by Maria Shulga on 22/05/2026.
//

import Foundation
import SQLite3

final class PickupPointRepository {
    static let shared = PickupPointRepository()
    private let db = DatabaseService.shared

    private init() {}

    func fetchAll() -> [PickupPoint] {
        var result: [PickupPoint] = []
        var stmt: OpaquePointer?
        let q = "SELECT id, title, address, latitude, longitude FROM pickup_points ORDER BY title;"
        if sqlite3_prepare_v2(db.database, q, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let id      = Int(sqlite3_column_int(stmt, 0))
                let title   = String(cString: sqlite3_column_text(stmt, 1))
                let address = String(cString: sqlite3_column_text(stmt, 2))
                let lat     = sqlite3_column_double(stmt, 3)
                let lng     = sqlite3_column_double(stmt, 4)
                result.append(PickupPoint(id: id, title: title,
                                          address: address,
                                          latitude: lat, longitude: lng))
            }
        }
        sqlite3_finalize(stmt)
        return result
    }
}
