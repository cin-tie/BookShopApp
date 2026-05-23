//
//  PickupPointDetailSheet.swift
//  BookShopApp
//
//  Created by Maria Shulga on 22/05/2026.
//

import SwiftUI
import MapKit

struct PickupPointDetailSheet: View {
    let point: PickupPoint
    let distance: String?
    var onConfirm: (PickupPoint) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Map(initialPosition: .region(MKCoordinateRegion(
                    center: point.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))) {
                    Marker(point.title, coordinate: point.coordinate)
                        .tint(Color.accent)
                }
                .frame(height: 200)
                .disabled(true)

                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(point.title)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "1E1B4B"))

                        HStack(spacing: 8) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundStyle(Color.accent)
                            Text(point.address)
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }

                        if let distance {
                            HStack(spacing: 8) {
                                Image(systemName: "figure.walk")
                                    .foregroundStyle(Color(hex: "22C55E"))
                                Text(distance + " from your location")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Working Hours")
                            .font(.system(size: 15, weight: .semibold))
                        HStack {
                            Text("Mon – Fri").font(.system(size: 14)).foregroundStyle(.secondary)
                            Spacer()
                            Text("09:00 – 21:00").font(.system(size: 14, weight: .medium))
                        }
                        HStack {
                            Text("Sat – Sun").font(.system(size: 14)).foregroundStyle(.secondary)
                            Spacer()
                            Text("10:00 – 19:00").font(.system(size: 14, weight: .medium))
                        }
                    }

                    Spacer()

                    PrimaryButton(title: "Select This Pickup Point") {
                        onConfirm(point)
                        dismiss()
                    }
                }
                .padding(24)
            }
            .navigationTitle("Pickup Point")
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
        .presentationDetents([.large])
    }
}
