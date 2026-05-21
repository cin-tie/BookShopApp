//
//  OrderRepository.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import Foundation
import SQLite3

final class OrderRepository {
    static let shared = OrderRepository()
    private let db = DatabaseService.shared

    private init() {}

    func createOrder(userId: Int, items: [CartItem], total: Double) -> Order? {
        let database = db.database
        let dateStr = ISO8601DateFormatter().string(from: Date())

        sqlite3_exec(database,
            "INSERT INTO orders (userId, status, totalPrice, createdAt) VALUES (\(userId), 'pending', \(total), '\(dateStr)');",
            nil, nil, nil)

        let orderId = Int(sqlite3_last_insert_rowid(database))
        guard orderId > 0 else { return nil }

        for item in items {
            sqlite3_exec(database,
                "INSERT INTO order_items (orderId, productId, quantity, subtotal) VALUES (\(orderId), \(item.product.id), \(item.quantity), \(item.subtotal));",
                nil, nil, nil)
        }

        return fetchOrder(id: orderId)
    }

    func fetchOrders(userId: Int) -> [Order] {
        let database = db.database
        var orders: [Order] = []
        var stmt: OpaquePointer?

        let q = "SELECT id, userId, status, totalPrice, createdAt FROM orders WHERE userId = \(userId) ORDER BY createdAt DESC;"
        if sqlite3_prepare_v2(database, q, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let id         = Int(sqlite3_column_int(stmt, 0))
                let uId        = Int(sqlite3_column_int(stmt, 1))
                let statusStr  = String(cString: sqlite3_column_text(stmt, 2))
                let total      = sqlite3_column_double(stmt, 3)
                let dateStr    = String(cString: sqlite3_column_text(stmt, 4))
                let date       = ISO8601DateFormatter().date(from: dateStr) ?? Date()
                let status     = OrderStatus(rawValue: statusStr) ?? .pending
                let items      = fetchOrderItems(orderId: id)
                orders.append(Order(id: id, userId: uId, status: status, totalPrice: total, createdAt: date, items: items))
            }
        }
        sqlite3_finalize(stmt)
        return orders
    }

    func confirmOrder(id: Int) {
        sqlite3_exec(db.database,
            "UPDATE orders SET status = 'confirmed' WHERE id = \(id);",
            nil, nil, nil)
    }
    
    func cancelOrder(id: Int) {
        sqlite3_exec(db.database,
            "UPDATE orders SET status = 'cancelled' WHERE id = \(id) AND status = 'pending';",
            nil, nil, nil)
    }

    func splitOrder(id: Int, itemIds: [Int]) -> Order? {
        guard let original = fetchOrder(id: id) else { return nil }
        let splitItems = original.items.filter { itemIds.contains($0.id) }
        guard !splitItems.isEmpty else { return nil }

        let splitTotal = splitItems.reduce(0) { $0 + $1.subtotal }
        let database = db.database
        let dateStr = ISO8601DateFormatter().string(from: Date())

        sqlite3_exec(database,
            "INSERT INTO orders (userId, status, totalPrice, createdAt) VALUES (\(original.userId), 'pending', \(splitTotal), '\(dateStr)');",
            nil, nil, nil)
        let newId = Int(sqlite3_last_insert_rowid(database))

        for item in splitItems {
            sqlite3_exec(database,
                "INSERT INTO order_items (orderId, productId, quantity, subtotal) VALUES (\(newId), \(item.product.id), \(item.quantity), \(item.subtotal));",
                nil, nil, nil)
            sqlite3_exec(database,
                "DELETE FROM order_items WHERE id = \(item.id);",
                nil, nil, nil)
        }

        // Recalc original total
        var stmt: OpaquePointer?
        var remainingTotal = 0.0
        if sqlite3_prepare_v2(database, "SELECT SUM(subtotal) FROM order_items WHERE orderId = \(id);", -1, &stmt, nil) == SQLITE_OK,
           sqlite3_step(stmt) == SQLITE_ROW {
            remainingTotal = sqlite3_column_double(stmt, 0)
        }
        sqlite3_finalize(stmt)
        sqlite3_exec(database, "UPDATE orders SET totalPrice = \(remainingTotal) WHERE id = \(id);", nil, nil, nil)

        return fetchOrder(id: newId)
    }

    // MARK: - Helpers

    private func fetchOrder(id: Int) -> Order? {
        let database = db.database
        var stmt: OpaquePointer?
        let q = "SELECT id, userId, status, totalPrice, createdAt FROM orders WHERE id = \(id);"
        var order: Order?
        if sqlite3_prepare_v2(database, q, -1, &stmt, nil) == SQLITE_OK,
           sqlite3_step(stmt) == SQLITE_ROW {
            let uId       = Int(sqlite3_column_int(stmt, 1))
            let statusStr = String(cString: sqlite3_column_text(stmt, 2))
            let total     = sqlite3_column_double(stmt, 3)
            let dateStr   = String(cString: sqlite3_column_text(stmt, 4))
            let date      = ISO8601DateFormatter().date(from: dateStr) ?? Date()
            let status    = OrderStatus(rawValue: statusStr) ?? .pending
            let items     = fetchOrderItems(orderId: id)
            order = Order(id: id, userId: uId, status: status, totalPrice: total, createdAt: date, items: items)
        }
        sqlite3_finalize(stmt)
        return order
    }

    private func fetchOrderItems(orderId: Int) -> [OrderItem] {
        let database = db.database
        var result: [OrderItem] = []
        var stmt: OpaquePointer?
        let q = """
            SELECT oi.id, oi.orderId, oi.quantity, oi.subtotal,
                   p.id, p.categoryId, p.title, p.description, p.price, p.stock, p.imageUrl
            FROM order_items oi
            JOIN products p ON oi.productId = p.id
            WHERE oi.orderId = \(orderId);
        """
        if sqlite3_prepare_v2(database, q, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let oiId  = Int(sqlite3_column_int(stmt, 0))
                let oId   = Int(sqlite3_column_int(stmt, 1))
                let qty   = Int(sqlite3_column_int(stmt, 2))
                let sub   = sqlite3_column_double(stmt, 3)
                let pId   = Int(sqlite3_column_int(stmt, 4))
                let pCat  = Int(sqlite3_column_int(stmt, 5))
                let pTit  = String(cString: sqlite3_column_text(stmt, 6))
                let pDesc = String(cString: sqlite3_column_text(stmt, 7))
                let pPri  = sqlite3_column_double(stmt, 8)
                let pSto  = Int(sqlite3_column_int(stmt, 9))
                let pImg  = sqlite3_column_text(stmt, 10).map { String(cString: $0) }
                let product = Product(id: pId, categoryId: pCat, title: pTit,
                                      description: pDesc, price: pPri, stock: pSto, imageUrl: pImg)
                result.append(OrderItem(id: oiId, orderId: oId, product: product, quantity: qty, subtotal: sub))
            }
        }
        sqlite3_finalize(stmt)
        return result
    }
}
