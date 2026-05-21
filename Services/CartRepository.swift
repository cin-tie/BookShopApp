//
//  CartRepository.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import Foundation
import SQLite3

final class CartRepository {
    static let shared = CartRepository()
    private let db = DatabaseService.shared

    private init() {}

    // MARK: - Cart

    private func ensureCart(userId: Int) -> Int {
        let database = db.database
        var stmt: OpaquePointer?
        // Try to find existing cart
        if sqlite3_prepare_v2(database, "SELECT id FROM carts WHERE userId = \(userId);", -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(stmt, 0))
                sqlite3_finalize(stmt)
                return id
            }
        }
        sqlite3_finalize(stmt)
        // Create new cart
        sqlite3_exec(database, "INSERT INTO carts (userId, totalPrice) VALUES (\(userId), 0);", nil, nil, nil)
        return Int(sqlite3_last_insert_rowid(database))
    }

    func fetchCartItems(userId: Int) -> [CartItem] {
        let cartId = ensureCart(userId: userId)
        let database = db.database
        var result: [CartItem] = []

        let query = """
            SELECT ci.id, ci.cartId, ci.quantity, ci.subtotal,
                   p.id, p.categoryId, p.title, p.description, p.price, p.stock, p.imageUrl
            FROM cart_items ci
            JOIN products p ON ci.productId = p.id
            WHERE ci.cartId = \(cartId);
        """

        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let ciId       = Int(sqlite3_column_int(stmt, 0))
                let ciCartId   = Int(sqlite3_column_int(stmt, 1))
                let qty        = Int(sqlite3_column_int(stmt, 2))
                let pId        = Int(sqlite3_column_int(stmt, 4))
                let pCatId     = Int(sqlite3_column_int(stmt, 5))
                let pTitle     = String(cString: sqlite3_column_text(stmt, 6))
                let pDesc      = String(cString: sqlite3_column_text(stmt, 7))
                let pPrice     = sqlite3_column_double(stmt, 8)
                let pStock     = Int(sqlite3_column_int(stmt, 9))
                let pImageUrl  = sqlite3_column_text(stmt, 10).map { String(cString: $0) }

                let product = Product(
                    id: pId, categoryId: pCatId, title: pTitle,
                    description: pDesc, price: pPrice, stock: pStock, imageUrl: pImageUrl
                )
                result.append(CartItem(id: ciId, cartId: ciCartId, product: product, quantity: qty))
            }
        }
        sqlite3_finalize(stmt)
        return result
    }

    func addProduct(_ productId: Int, userId: Int) {
        let cartId = ensureCart(userId: userId)
        let database = db.database
        var stmt: OpaquePointer?

        // Check if already in cart
        let check = "SELECT id, quantity FROM cart_items WHERE cartId = \(cartId) AND productId = \(productId);"
        if sqlite3_prepare_v2(database, check, -1, &stmt, nil) == SQLITE_OK,
           sqlite3_step(stmt) == SQLITE_ROW {
            let itemId = Int(sqlite3_column_int(stmt, 0))
            let qty    = Int(sqlite3_column_int(stmt, 1)) + 1
            sqlite3_finalize(stmt)
            updateQuantity(itemId: itemId, quantity: qty, userId: userId)
            return
        }
        sqlite3_finalize(stmt)

        // Insert new
        let price = fetchProductPrice(productId)
        sqlite3_exec(database,
            "INSERT INTO cart_items (cartId, productId, quantity, subtotal) VALUES (\(cartId), \(productId), 1, \(price));",
            nil, nil, nil)
        recalcTotal(cartId: cartId)
    }

    func updateQuantity(itemId: Int, quantity: Int, userId: Int) {
        let cartId = ensureCart(userId: userId)
        let database = db.database
        if quantity <= 0 {
            sqlite3_exec(database, "DELETE FROM cart_items WHERE id = \(itemId);", nil, nil, nil)
        } else {
            let price = fetchItemPrice(itemId: itemId)
            let subtotal = price * Double(quantity)
            sqlite3_exec(database,
                "UPDATE cart_items SET quantity = \(quantity), subtotal = \(subtotal) WHERE id = \(itemId);",
                nil, nil, nil)
        }
        recalcTotal(cartId: cartId)
    }

    func removeItem(itemId: Int, userId: Int) {
        let cartId = ensureCart(userId: userId)
        sqlite3_exec(db.database, "DELETE FROM cart_items WHERE id = \(itemId);", nil, nil, nil)
        recalcTotal(cartId: cartId)
    }

    func clearCart(userId: Int) {
        let cartId = ensureCart(userId: userId)
        sqlite3_exec(db.database, "DELETE FROM cart_items WHERE cartId = \(cartId);", nil, nil, nil)
        sqlite3_exec(db.database, "UPDATE carts SET totalPrice = 0 WHERE id = \(cartId);", nil, nil, nil)
    }

    func cartTotal(userId: Int) -> Double {
        let cartId = ensureCart(userId: userId)
        var stmt: OpaquePointer?
        var total = 0.0
        if sqlite3_prepare_v2(db.database, "SELECT totalPrice FROM carts WHERE id = \(cartId);", -1, &stmt, nil) == SQLITE_OK,
           sqlite3_step(stmt) == SQLITE_ROW {
            total = sqlite3_column_double(stmt, 0)
        }
        sqlite3_finalize(stmt)
        return total
    }

    // MARK: - Helpers

    private func recalcTotal(cartId: Int) {
        let database = db.database
        var stmt: OpaquePointer?
        var total = 0.0
        if sqlite3_prepare_v2(database, "SELECT SUM(subtotal) FROM cart_items WHERE cartId = \(cartId);", -1, &stmt, nil) == SQLITE_OK,
           sqlite3_step(stmt) == SQLITE_ROW {
            total = sqlite3_column_double(stmt, 0)
        }
        sqlite3_finalize(stmt)
        sqlite3_exec(database, "UPDATE carts SET totalPrice = \(total) WHERE id = \(cartId);", nil, nil, nil)
    }

    private func fetchProductPrice(_ productId: Int) -> Double {
        var stmt: OpaquePointer?
        var price = 0.0
        if sqlite3_prepare_v2(db.database, "SELECT price FROM products WHERE id = \(productId);", -1, &stmt, nil) == SQLITE_OK,
           sqlite3_step(stmt) == SQLITE_ROW {
            price = sqlite3_column_double(stmt, 0)
        }
        sqlite3_finalize(stmt)
        return price
    }

    private func fetchItemPrice(itemId: Int) -> Double {
        var stmt: OpaquePointer?
        var price = 0.0
        let q = "SELECT p.price FROM cart_items ci JOIN products p ON ci.productId = p.id WHERE ci.id = \(itemId);"
        if sqlite3_prepare_v2(db.database, q, -1, &stmt, nil) == SQLITE_OK,
           sqlite3_step(stmt) == SQLITE_ROW {
            price = sqlite3_column_double(stmt, 0)
        }
        sqlite3_finalize(stmt)
        return price
    }
}
