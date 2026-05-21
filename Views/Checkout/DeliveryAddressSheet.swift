//
//  DeliveryAddressSheet.swift
//  BookShopApp
//
//  Created by Maria Shulga on 21/05/2026.
//

import SwiftUI

struct DeliveryAddressSheet: View {
    @ObservedObject var viewModel: CheckoutViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showAddForm = false

    var body: some View {
        NavigationStack {
            List {
                // Existing addresses
                if !viewModel.addresses.isEmpty {
                    Section("Saved addresses") {
                        ForEach(viewModel.addresses) { address in
                            Button {
                                viewModel.selectedAddress = address
                                dismiss()
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(address.fullAddress)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundStyle(Color(.label))
                                        if !address.postalCode.isEmpty {
                                            Text(address.postalCode)
                                                .font(.system(size: 13))
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    Spacer()
                                    if viewModel.selectedAddress?.id == address.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(Color.accent)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(.plain)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewModel.deleteAddress(address)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }

                // Add new
                Section {
                    Button {
                        showAddForm.toggle()
                    } label: {
                        Label("Add new address", systemImage: "plus.circle.fill")
                            .foregroundStyle(Color.accent)
                            .font(.system(size: 15, weight: .medium))
                    }
                    .buttonStyle(.plain)

                    if showAddForm {
                        addAddressForm
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Delivery Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accent)
                }
            }
        }
        .presentationDetents([.large])
    }

    private var addAddressForm: some View {
        VStack(spacing: 12) {
            InputField(title: "City", placeholder: "e.g. New York",
                       text: $viewModel.newCity)
            InputField(title: "Street", placeholder: "e.g. 5th Avenue",
                       text: $viewModel.newStreet)
            InputField(title: "House / Apt", placeholder: "e.g. 42B",
                       text: $viewModel.newHouse)
            InputField(title: "Postal Code", placeholder: "e.g. 10001",
                       text: $viewModel.newPostal,
                       keyboardType: .numbersAndPunctuation)

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.system(size: 13))
                    .foregroundStyle(.red)
            }

            PrimaryButton(title: "Save Address") {
                if viewModel.saveNewAddress() {
                    showAddForm = false
                    dismiss()
                }
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 8)
    }
}
