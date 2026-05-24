//
//  CatalogViewModel.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import Foundation
import Combine

@MainActor
final class CatalogViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var categories: [Category] = []
    @Published var selectedCategory: Category = .all
    @Published var searchText: String = ""
    @Published var isLoading = false

    private let db = DatabaseService.shared
    private var searchTask: Task<Void, Never>?

    init() {
        loadCategories()
        loadProducts()
    }

    func loadCategories() {
        var all = [Category.all]
        all += db.fetchCategories()
        categories = all
    }

    func loadProducts() {
        isLoading = true
        let catId = selectedCategory.id == 0 ? nil : selectedCategory.id
        let query = searchText
        Task {
            let result = db.fetchProducts(categoryId: catId, search: query)
            self.products = result
            self.isLoading = false
        }
    }

    func select(category: Category) {
        selectedCategory = category
        loadProducts()
    }

    func onSearchChange(_ text: String) {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 350_000_000) // 350ms debounce
            guard !Task.isCancelled else { return }
            loadProducts()
        }
    }
}
