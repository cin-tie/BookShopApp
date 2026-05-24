//
//  PickupMapView.swift
//  BookShopApp
//
//  Created by Maria Shulga on 22/05/2026.
//

import SwiftUI
import MapKit

struct PickupMapView: View {
    @StateObject private var viewModel = PickupMapViewModel()
    var onSelectPoint: ((PickupPoint) -> Void)? = nil
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // MARK: Map
                Map(position: Binding(
                    get: { viewModel.cameraPosition },
                    set: { viewModel.cameraPosition = $0 }
                )) {
                    UserAnnotation()
                    ForEach(viewModel.pickupPoints) { point in
                        Annotation(point.title, coordinate: point.coordinate) {
                            PickupAnnotationView(
                                isSelected: viewModel.selectedPoint?.id == point.id
                            ) {
                                viewModel.select(point)
                            }
                        }
                    }
                }
                .mapControls {
                    MapCompass()
                    MapScaleView()
                }
                .ignoresSafeArea(edges: .top)
                // MARK: Location button
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            viewModel.centerOnUser()
                        } label: {
                            Image(systemName: "location.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.accent)
                                .frame(width: 44, height: 44)
                                .background(Color(.systemBackground))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.12), radius: 6, y: 2)
                        }
                        .padding(.trailing, 16)
                    }
                    Spacer()
                }
                .padding(.top, 16)

                // MARK: Bottom list
                VStack(spacing: 0) {
                    // Handle
                    Capsule()
                        .fill(Color(.systemGray4))
                        .frame(width: 36, height: 4)
                        .padding(.top, 10)
                        .padding(.bottom, 14)

                    Text("Pickup Points")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 10) {
                            ForEach(viewModel.pickupPoints) { point in
                                PickupPointCard(
                                    point: point,
                                    isSelected: viewModel.selectedPoint?.id == point.id,
                                    distance: viewModel.distance(to: point)
                                ) {
                                    viewModel.select(point)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                    .frame(height: 260)
                }
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 16, y: -4)
                )
            }
            .navigationTitle("Select Pickup Point")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundStyle(.secondary)
                }
            }
            .onAppear { viewModel.requestLocation() }
            .sheet(isPresented: $viewModel.showDetail) {
                if let point = viewModel.selectedPoint {
                    PickupPointDetailSheet(
                        point: point,
                        distance: viewModel.distance(to: point)
                    ) { confirmed in
                        onSelectPoint?(confirmed)
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Map Annotation View

private struct PickupAnnotationView: View {
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.accent : Color(.systemBackground))
                        .frame(width: isSelected ? 44 : 36, height: isSelected ? 44 : 36)
                        .shadow(color: .black.opacity(0.15), radius: 4, y: 2)

                    Image(systemName: "storefront.fill")
                        .font(.system(size: isSelected ? 20 : 16))
                        .foregroundStyle(isSelected ? .white : Color.accent)
                }

                // Pin triangle
                Triangle()
                    .fill(isSelected ? Color.accent : Color(.systemBackground))
                    .frame(width: 10, height: 6)
            }
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

#Preview("Pickup Map") {
    PickupMapView()
}
