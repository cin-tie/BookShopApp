//
//  ProductCard.swift
//  BookShopApp
//
//  Created by Maria Shulga on 20/05/2026.
//

import SwiftUI

struct ProductCard: View {
    let product: Product
    var onAddToCart: () -> Void = {}
    var onTap: () -> Void = {}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: product.imageUrl ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure, .empty:
                        ZStack {
                            Color(.systemGray5)
                            Image(systemName: "book.closed.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(Color.accent.opacity(0.4))
                        }
                    @unknown default:
                        Color(.systemGray5)
                    }
                }
                .frame(height: 160)
                .clipped()
                
                if !product.isAvailable {
                    Text("Out of stock")
                        .font(.system(size: 10, weight: .semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.black.opacity(0.6))
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                        .padding(8)
                }
            }
            
            // Info area
            VStack(alignment: .leading, spacing: 6) {
                Text(product.title)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(2)
                    .foregroundStyle(Color(.label))
                
                HStack {
                    Text(product.formattedPrice)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color.accent)
                    
                    Spacer()
                    
                    Button(action: onAddToCart) {
                        Image(systemName: "plus")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 30, height: 30)
                            .background(product.isAvailable ? Color.accent : Color(.systemGray4))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)     
                    .accessibilityIdentifier("addToCartButton\(product.id)")
                    .disabled(!product.isAvailable)
                }
            }
            .padding(12)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 2)
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
        .accessibilityIdentifier("productCard_\(product.id)")
    }
}

#Preview("Product Card") {
    ProductCard(
        product: Product(
            id: 1, categoryId: 1,
            title: "The Midnight Library",
            description: "A novel about all the lives you could have lived.",
            price: 14.99, stock: 5,
            imageUrl: "https://covers.openlibrary.org/b/id/10909258-L.jpg"
        ),
        onAddToCart: { print("Added to cart") },
        onTap: { print("Open details") }
    )
    .frame(width: 180)
    .padding()
}
