//
//  CatalogView.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import SwiftUI

struct CatalogView: View {
    @StateObject private var viewModel = CatalogViewModel()
    @EnvironmentObject private var session: SessionService
    @State private var selectedProduct: Product?
    var cartViewModel: CartViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hello, \(session.currentUser?.name.components(separatedBy: " ").first ?? "there")!")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "1E1B4B"))

                        Text("What are you looking for today?")
                            .font(.system(size: 15))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 20)

                    // MARK: Search
                    SearchBar(
                        text: $viewModel.searchText,
                        placeholder: "Search books & stationery...",
                        onChange: viewModel.onSearchChange
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                    // MARK: Categories
                    Text("Categories")
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.categories) { category in
                                CategoryChip(
                                    category: category,
                                    isSelected: viewModel.selectedCategory == category
                                ) {
                                    viewModel.select(category: category)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 24)

                    // MARK: Products
                    HStack {
                        Text(viewModel.selectedCategory.id == 0
                             ? "All Products"
                             : viewModel.selectedCategory.title)
                            .font(.system(size: 17, weight: .semibold))

                        Spacer()

                        Text("\(viewModel.products.count) items")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 14)

                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                    } else if viewModel.products.isEmpty {
                        emptyState
                    } else {
                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(viewModel.products) { product in
                                ProductCard(
                                    product: product,
                                    onAddToCart: { cartViewModel.addProduct(product) },
                                    onTap: { selectedProduct = product }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                    Spacer().frame(height: 30)
                }
            }
            .accessibilityIdentifier("catalogScreen")
            .scrollIndicators(.hidden)
            .navigationBarHidden(true)
            .sheet(item: $selectedProduct) { product in
                ProductDetailView(product: product, cartViewModel: cartViewModel)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 44))
                .foregroundStyle(Color.accent.opacity(0.4))

            Text("No results found")
                .font(.system(size: 17, weight: .semibold))
                .accessibilityIdentifier("emptyCatalogLabel")

            Text("Try a different search or category")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

#Preview("Catalog Light") {
    CatalogView(cartViewModel: CartViewModel())
        .environmentObject(SessionService.shared)
}

#Preview("Catalog Dark") {
    CatalogView(cartViewModel: CartViewModel())
        .environmentObject(SessionService.shared)
        .preferredColorScheme(.dark)
}
