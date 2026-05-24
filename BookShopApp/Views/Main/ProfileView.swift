//
//  ProfileView.swift
//  BookShopApp
//
//  Created by Maria Shulga on 23/05/2026.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var session: SessionService
    @State private var showOrders = false
    @State private var showAddresses = false
    @State private var showChangeUsername = false
    @State private var showChangePassword = false
    @State private var showPaymentMethods = false

    var body: some View {
        NavigationStack {
            List {
                // MARK: - Header
                Section {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.accent.opacity(0.12))
                                .frame(width: 64, height: 64)
                            Text(initials)
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color.accent)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(session.currentUser?.name ?? "")
                                .font(.system(size: 18, weight: .semibold))
                            Text(session.currentUser?.email ?? "")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                // MARK: - Orders & Payments
                Section("Shopping") {
                    profileRow(icon: "clock.arrow.circlepath", iconColor: "4F46E5",
                               title: "My Orders") {
                        showOrders = true
                    }
                    profileRow(icon: "creditcard.fill", iconColor: "22C55E",
                               title: "Payment Methods") {
                        showPaymentMethods = true
                    }
                    profileRow(icon: "mappin.circle.fill", iconColor: "F59E0B",
                               title: "Delivery Addresses") {
                        showAddresses = true
                    }
                }

                // MARK: - Account
                Section("Account") {
                    profileRow(icon: "person.fill", iconColor: "6366F1",
                               title: "Change Username") {
                        showChangeUsername = true
                    }
                    profileRow(icon: "lock.fill", iconColor: "8B5CF6",
                               title: "Change Password") {
                        showChangePassword = true
                    }
                }

                // MARK: - Logout
                Section {
                    Button {
                        session.logout()
                    } label: {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red.opacity(0.12))
                                    .frame(width: 32, height: 32)
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.red)
                            }
                            Text("Logout")
                                .foregroundStyle(.red)
                                .font(.system(size: 16))
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Profile")
            .accessibilityIdentifier("profileNavBar")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $showOrders) {
                OrdersFromProfileView()
            }
            .sheet(isPresented: $showAddresses) {
                AddressesFromProfileView()
            }
            .sheet(isPresented: $showPaymentMethods) {
                PaymentMethodsInfoView()
            }
            .sheet(isPresented: $showChangeUsername) {
                ChangeUsernameView()
            }
            .sheet(isPresented: $showChangePassword) {
                ChangePasswordView()
            }
        }
    }

    private var initials: String {
        let parts = (session.currentUser?.name ?? "?")
            .components(separatedBy: " ")
            .prefix(2)
            .compactMap { $0.first }
        return String(parts).uppercased()
    }

    private func profileRow(icon: String, iconColor: String,
                             title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: iconColor).opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: iconColor))
                }
                Text(title)
                    .font(.system(size: 16))
                    .foregroundStyle(Color(.label))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(.tertiaryLabel))
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Orders from Profile

private struct OrdersFromProfileView: View {
    @StateObject private var vm = CartViewModel()

    var body: some View {
        OrdersListView(viewModel: vm)
            .onAppear { vm.loadOrders() }
    }
}

// MARK: - Addresses from Profile

private struct AddressesFromProfileView: View {
    @EnvironmentObject private var session: SessionService
    @Environment(\.dismiss) private var dismiss
    @State private var addresses: [DeliveryAddress] = []
    @State private var showAddForm = false
    @State private var newCity = ""
    @State private var newStreet = ""
    @State private var newHouse = ""
    @State private var newPostal = ""

    private let repo = DeliveryAddressRepository.shared

    var body: some View {
        NavigationStack {
            List {
                if !addresses.isEmpty {
                    Section("Saved") {
                        ForEach(addresses) { address in
                            VStack(alignment: .leading, spacing: 3) {
                                Text(address.fullAddress)
                                    .font(.system(size: 14, weight: .medium))
                                if !address.postalCode.isEmpty {
                                    Text(address.postalCode)
                                        .font(.system(size: 13))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    repo.deleteAddress(id: address.id)
                                    load()
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }

                Section {
                    Button {
                        withAnimation { showAddForm.toggle() }
                    } label: {
                        Label("Add new address", systemImage: "plus.circle.fill")
                            .foregroundStyle(Color.accent)
                    }
                    .buttonStyle(.plain)

                    if showAddForm {
                        InputField(title: "City", placeholder: "e.g. New York", text: $newCity)
                        InputField(title: "Street", placeholder: "e.g. 5th Avenue", text: $newStreet)
                        InputField(title: "House / Apt", placeholder: "e.g. 42B", text: $newHouse)
                        InputField(title: "Postal Code", placeholder: "e.g. 10001",
                                   text: $newPostal, keyboardType: .numbersAndPunctuation)
                        PrimaryButton(title: "Save") { save() }
                            .padding(.vertical, 8)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Delivery Addresses")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.foregroundStyle(Color.accent)
                }
            }
            .onAppear { load() }
        }
        .presentationDetents([.large])
    }

    private func load() {
        let userId = SessionService.shared.stableUserId()
        addresses = repo.fetchAddresses(userId: userId)
    }

    private func save() {
        let userId = SessionService.shared.stableUserId()
        guard !newCity.isEmpty, !newStreet.isEmpty, !newHouse.isEmpty else { return }
        let draft = DeliveryAddress(id: 0, userId: userId,
            city: newCity, street: newStreet, house: newHouse, postalCode: newPostal)
        _ = repo.saveAddress(draft)
        newCity = ""; newStreet = ""; newHouse = ""; newPostal = ""
        showAddForm = false
        load()
    }
}

// MARK: - Payment Methods Info

private struct PaymentMethodsInfoView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(PaymentMethod.allCases) { method in
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.accent.opacity(0.1))
                            .frame(width: 44, height: 44)
                        Image(systemName: method.icon)
                            .font(.system(size: 18))
                            .foregroundStyle(Color.accent)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text(method.displayName)
                            .font(.system(size: 15, weight: .medium))
                        Text(method.description)
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Payment Methods")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.foregroundStyle(Color.accent)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Change Username

private struct ChangeUsernameView: View {
    @EnvironmentObject private var session: SessionService
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var error: String?
    @State private var success = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                InputField(title: "New Name", placeholder: "Enter your name", text: $name)

                if let error {
                    Text(error).font(.system(size: 13)).foregroundStyle(.red)
                }
                if success {
                    Text("Name updated!").font(.system(size: 13))
                        .foregroundStyle(Color(hex: "22C55E"))
                }

                PrimaryButton(title: "Save") { save() }
                Spacer()
            }
            .padding(24)
            .navigationTitle("Change Username")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { dismiss() }.foregroundStyle(.secondary)
                }
            }
            .onAppear { name = session.currentUser?.name ?? "" }
        }
        .presentationDetents([.medium])
    }

    private func save() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            error = "Name cannot be empty"; return
        }
        session.updateName(name)
        success = true
        error = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { dismiss() }
    }
}

// MARK: - Change Password

private struct ChangePasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var current = ""
    @State private var newPass = ""
    @State private var confirm = ""
    @State private var error: String?
    @State private var success = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                InputField(title: "Current Password", placeholder: "••••••••",
                           text: $current, isSecure: true)
                InputField(title: "New Password", placeholder: "Min. 8 characters",
                           text: $newPass, isSecure: true)
                InputField(title: "Confirm Password", placeholder: "Repeat new password",
                           text: $confirm, isSecure: true)

                if let error {
                    Text(error).font(.system(size: 13)).foregroundStyle(.red)
                }
                if success {
                    Text("Password updated!").font(.system(size: 13))
                        .foregroundStyle(Color(hex: "22C55E"))
                }

                PrimaryButton(title: "Update Password") { save() }
                Spacer()
            }
            .padding(24)
            .navigationTitle("Change Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { dismiss() }.foregroundStyle(.secondary)
                }
            }
        }
        .presentationDetents([.large])
    }

    private func save() {
        guard newPass.count >= 8 else {
            error = "Password must be at least 8 characters"; return
        }
        guard newPass == confirm else {
            error = "Passwords do not match"; return
        }
        // Demo — просто показываем успех
        success = true
        error = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { dismiss() }
    }
}

#Preview("Profile Light") {
    ProfileView()
        .environmentObject(SessionService.shared)
}

#Preview("Profile Dark") {
    ProfileView()
        .environmentObject(SessionService.shared)
        .preferredColorScheme(.dark)
}
