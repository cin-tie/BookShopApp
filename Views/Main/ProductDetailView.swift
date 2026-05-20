//
//  ProductDetailView.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Environment(\.dismiss) private var dismiss
    @State private var appear = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero image
                    AsyncImage(url: URL(string: product.imageUrl ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFit()
                        case .failure, .empty:
                            ZStack {
                                Color(.systemGray5)
                                Image(systemName: "book.closed.fill")
                                    .font(.system(size: 64))
                                    .foregroundStyle(Color.accent.opacity(0.35))
                            }
                            .frame(height: 280)
                        @unknown default:
                            Color(.systemGray5).frame(height: 280)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))

                    VStack(alignment: .leading, spacing: 16) {
                        // Title + Price
                        VStack(alignment: .leading, spacing: 6) {
                            Text(product.title)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(hex: "1E1B4B"))

                            Text(product.formattedPrice)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(Color.accent)
                        }

                        // Availability badge
                        HStack(spacing: 6) {
                            Circle()
                                .fill(product.isAvailable ? Color(hex: "22C55E") : .red)
                                .frame(width: 8, height: 8)
                            Text(product.isAvailable ? "In stock (\(product.stock) left)" : "Out of stock")
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                        }

                        Divider()

                        // Description
                        Text("About")
                            .font(.system(size: 15, weight: .semibold))
                        Text(product.description)
                            .font(.system(size: 15))
                            .foregroundStyle(.secondary)
                            .lineSpacing(4)

                        Spacer().frame(height: 24)

                        // Add to cart button
                        PrimaryButton(
                            title: product.isAvailable ? "Add to Cart" : "Out of Stock"
                        ) {
                            // Cart integration in cart module
                        }
                        .disabled(!product.isAvailable)
                        .opacity(product.isAvailable ? 1 : 0.5)
                    }
                    .padding(24)
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                }
            }
        }
    }
}

#Preview("Product Detail") {
    ProductDetailView(product: Product(
        id: 1, categoryId: 1,
        title: "The Midnight Library",
        description: "A novel about all the lives you could have lived. Between life and death there is a library.",
        price: 14.99, stock: 5,
        imageUrl: "https://covers.openlibrary.org/b/id/10909258-L.jpg"
    ))
}
