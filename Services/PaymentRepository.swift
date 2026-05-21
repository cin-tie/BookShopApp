//
//  PaymentRepository.swift
//  BookShopApp
//
//  Created by Maria Shulga on 21/05/2026.
//

import Foundation
import SQLite3

final class PaymentRepository {
    static let shared = PaymentRepository()
    private let db = DatabaseService.shared

    private init() {}

    func createPayment(orderId: Int, method: PaymentMethod, amount: Double) -> Payment? {
        let database = db.database
        let sql = """
            INSERT INTO payments (orderId, paymentMethod, amount, paymentStatus)
            VALUES (\(orderId), '\(method.rawValue)', \(amount), 'pending');
        """
        guard sqlite3_exec(database, sql, nil, nil, nil) == SQLITE_OK else { return nil }
        let paymentId = Int(sqlite3_last_insert_rowid(database))
        return Payment(id: paymentId, orderId: orderId,
                       paymentMethod: method, amount: amount, status: .pending)
    }

    func updateStatus(paymentId: Int, status: PaymentStatus) {
        sqlite3_exec(db.database,
            "UPDATE payments SET paymentStatus = '\(status.rawValue)' WHERE id = \(paymentId);",
            nil, nil, nil)
    }

    func fetchPayment(orderId: Int) -> Payment? {
        let database = db.database
        var stmt: OpaquePointer?
        var payment: Payment?
        let q = "SELECT id, orderId, paymentMethod, amount, paymentStatus FROM payments WHERE orderId = \(orderId);"
        if sqlite3_prepare_v2(database, q, -1, &stmt, nil) == SQLITE_OK,
           sqlite3_step(stmt) == SQLITE_ROW {
            let id         = Int(sqlite3_column_int(stmt, 0))
            let oId        = Int(sqlite3_column_int(stmt, 1))
            let methodStr  = String(cString: sqlite3_column_text(stmt, 2))
            let amount     = sqlite3_column_double(stmt, 3)
            let statusStr  = String(cString: sqlite3_column_text(stmt, 4))
            let method     = PaymentMethod(rawValue: methodStr) ?? .cash
            let status     = PaymentStatus(rawValue: statusStr) ?? .pending
            payment = Payment(id: id, orderId: oId,
                              paymentMethod: method, amount: amount, status: status)
        }
        sqlite3_finalize(stmt)
        return payment
    }
}
