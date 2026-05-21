//
//  DatabaseService.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import Foundation
import SQLite3

final class DatabaseService {
    static let shared = DatabaseService()
    private var db: OpaquePointer?

    private init() {
        openDatabase()
        createTables()
        seedIfNeeded()
    }

    // MARK: - Setup

    private func openDatabase() {
        let path = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("bookshop.sqlite").path

        if sqlite3_open(path, &db) != SQLITE_OK {
            print("Cannot open database")
        }
    }

    private func createTables() {
        let statements = [
            """
            CREATE TABLE IF NOT EXISTS categories (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                icon TEXT NOT NULL
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS products (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                categoryId INTEGER NOT NULL,
                title TEXT NOT NULL,
                description TEXT NOT NULL,
                price REAL NOT NULL,
                stock INTEGER NOT NULL DEFAULT 0,
                imageUrl TEXT,
                FOREIGN KEY (categoryId) REFERENCES categories(id)
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS carts (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                userId INTEGER NOT NULL UNIQUE,
                totalPrice REAL NOT NULL DEFAULT 0,
                FOREIGN KEY (userId) REFERENCES users(id)
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS cart_items (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                cartId INTEGER NOT NULL,
                productId INTEGER NOT NULL,
                quantity INTEGER NOT NULL DEFAULT 1,
                subtotal REAL NOT NULL DEFAULT 0,
                FOREIGN KEY (cartId) REFERENCES carts(id),
                FOREIGN KEY (productId) REFERENCES products(id)
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS orders (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                userId INTEGER NOT NULL,
                pickupPointId INTEGER,
                status TEXT NOT NULL DEFAULT 'pending',
                totalPrice REAL NOT NULL DEFAULT 0,
                createdAt TEXT NOT NULL,
                FOREIGN KEY (userId) REFERENCES users(id)
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS order_items (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                orderId INTEGER NOT NULL,
                productId INTEGER NOT NULL,
                quantity INTEGER NOT NULL,
                subtotal REAL NOT NULL,
                FOREIGN KEY (orderId) REFERENCES orders(id),
                FOREIGN KEY (productId) REFERENCES products(id)
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS payments (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                orderId INTEGER NOT NULL UNIQUE,
                paymentMethod TEXT NOT NULL,
                amount REAL NOT NULL,
                paymentStatus TEXT NOT NULL DEFAULT 'pending',
                FOREIGN KEY (orderId) REFERENCES orders(id)
            );
            """
        ]
        statements.forEach { exec($0) }
    }

    // MARK: - Seed Data

    private func seedIfNeeded() {
        guard countRows(in: "categories") == 0 else { return }

        let categories: [(String, String)] = [
            ("Fiction", "book.fill"),
            ("Non-Fiction", "brain.head.profile"),
            ("Science", "atom"),
            ("Art & Design", "paintpalette.fill"),
            ("Stationery", "pencil.and.ruler.fill")
        ]

        for (title, icon) in categories {
            exec("INSERT INTO categories (title, icon) VALUES ('\(title)', '\(icon)');")
        }

        let products: [(Int, String, String, Double, Int, String)] = [
            (1, "The Midnight Library", "A novel about all the lives you could have lived.", 14.99, 23, "https://covers.openlibrary.org/b/id/10909258-L.jpg"),
            (1, "Project Hail Mary", "An astronaut wakes up alone in space.", 16.99, 15, "https://covers.openlibrary.org/b/id/10527843-L.jpg"),
            (1, "Circe", "The story of the witch of Greek myth.", 13.99, 30, "https://covers.openlibrary.org/b/id/8739161-L.jpg"),
            (1, "The Name of the Wind", "The tale of a legendary wizard.", 15.99, 12, "https://covers.openlibrary.org/b/id/8388636-L.jpg"),
            (2, "Atomic Habits", "Tiny changes, remarkable results.", 17.99, 40, "https://covers.openlibrary.org/b/id/10130533-L.jpg"),
            (2, "Sapiens", "A brief history of humankind.", 18.99, 25, "https://covers.openlibrary.org/b/id/8758981-L.jpg"),
            (2, "Deep Work", "Rules for focused success.", 15.99, 18, "https://covers.openlibrary.org/b/id/9252896-L.jpg"),
            (3, "A Brief History of Time", "From the big bang to black holes.", 12.99, 20, "https://covers.openlibrary.org/b/id/8372504-L.jpg"),
            (3, "The Elegant Universe", "Superstrings and the theory of everything.", 14.99, 10, "https://covers.openlibrary.org/b/id/240726-L.jpg"),
            (4, "The Elements of Style", "The classic guide to writing.", 11.99, 35, "https://covers.openlibrary.org/b/id/7898591-L.jpg"),
            (4, "Steal Like an Artist", "10 things nobody told you about creativity.", 13.99, 22, "https://covers.openlibrary.org/b/id/8157356-L.jpg"),
            (5, "Leuchtturm1917 Notebook", "Hardcover dotted journal, A5.", 24.99, 50, "https://images.unsplash.com/photo-1531346878377-a5be20888e57?w=400"),
            (5, "Staedtler Pencil Set", "12-piece premium graphite set.", 9.99, 60, "https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?w=400")
        ]

        for (catId, title, desc, price, stock, url) in products {
            let safe = title.replacingOccurrences(of: "'", with: "''")
            let safeDesc = desc.replacingOccurrences(of: "'", with: "''")
            exec("""
                INSERT INTO products (categoryId, title, description, price, stock, imageUrl)
                VALUES (\(catId), '\(safe)', '\(safeDesc)', \(price), \(stock), '\(url)');
            """)
        }
    }

    // MARK: - Public API

    func fetchCategories() -> [Category] {
        var result: [Category] = []
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, "SELECT id, title, icon FROM categories ORDER BY id;", -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let id    = Int(sqlite3_column_int(stmt, 0))
                let title = String(cString: sqlite3_column_text(stmt, 1))
                let icon  = String(cString: sqlite3_column_text(stmt, 2))
                result.append(Category(id: id, title: title, icon: icon))
            }
        }
        sqlite3_finalize(stmt)
        return result
    }

    func fetchProducts(categoryId: Int? = nil, search: String = "") -> [Product] {
        var result: [Product] = []
        var query = "SELECT id, categoryId, title, description, price, stock, imageUrl FROM products"
        var conditions: [String] = []

        if let cid = categoryId {
            conditions.append("categoryId = \(cid)")
        }
        if !search.trimmingCharacters(in: .whitespaces).isEmpty {
            let safe = search.replacingOccurrences(of: "'", with: "''")
            conditions.append("title LIKE '%\(safe)%'")
        }
        if !conditions.isEmpty {
            query += " WHERE " + conditions.joined(separator: " AND ")
        }
        query += " ORDER BY title;"

        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let id       = Int(sqlite3_column_int(stmt, 0))
                let catId    = Int(sqlite3_column_int(stmt, 1))
                let title    = String(cString: sqlite3_column_text(stmt, 2))
                let desc     = String(cString: sqlite3_column_text(stmt, 3))
                let price    = sqlite3_column_double(stmt, 4)
                let stock    = Int(sqlite3_column_int(stmt, 5))
                let imageUrl = sqlite3_column_text(stmt, 6).map { String(cString: $0) }
                result.append(Product(
                    id: id, categoryId: catId, title: title,
                    description: desc, price: price, stock: stock, imageUrl: imageUrl
                ))
            }
        }
        sqlite3_finalize(stmt)
        return result
    }

    // MARK: - Helpers

    private func exec(_ sql: String) {
        var err: UnsafeMutablePointer<CChar>?
        if sqlite3_exec(db, sql, nil, nil, &err) != SQLITE_OK,
           let msg = err { print("SQL error: \(String(cString: msg))") }
    }

    private func countRows(in table: String) -> Int {
        var stmt: OpaquePointer?
        var count = 0
        if sqlite3_prepare_v2(db, "SELECT COUNT(*) FROM \(table);", -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_ROW { count = Int(sqlite3_column_int(stmt, 0)) }
        }
        sqlite3_finalize(stmt)
        return count
    }

    var database: OpaquePointer? { db }
}
