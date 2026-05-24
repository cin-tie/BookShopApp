//
//  PickupMapViewModel.swift
//  BookShopApp
//
//  Created by Maria Shulga on 22/05/2026.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

@MainActor
final class PickupMapViewModel: NSObject, ObservableObject {

    @Published var pickupPoints: [PickupPoint] = []
    @Published var selectedPoint: PickupPoint?
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7549, longitude: -73.9840),
        span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
    )
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var locationAuthStatus: CLAuthorizationStatus = .notDetermined
    @Published var showDetail = false
    @Published var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.7549, longitude: -73.9840),
            span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
        )
    )

    private let repo = PickupPointRepository.shared
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        load()
    }

    func load() {
        pickupPoints = repo.fetchAll()
    }

    func requestLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        default:
            break
        }
    }

    func select(_ point: PickupPoint) {
        selectedPoint = point
        showDetail = true
        withAnimation {
            region = MKCoordinateRegion(
                center: point.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        }
    }

    func centerOnUser() {
        guard let loc = userLocation else {
            requestLocation()
            return
        }
        withAnimation {
            region = MKCoordinateRegion(
                center: loc,
                span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
            )
        }
    }

    func distance(to point: PickupPoint) -> String? {
        guard let userLoc = userLocation else { return nil }
        let from = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
        let to   = CLLocation(latitude: point.latitude, longitude: point.longitude)
        let meters = from.distance(from: to)
        return meters < 1000
            ? "\(Int(meters)) m"
            : String(format: "%.1f km", meters / 1000)
    }
}

// MARK: - CLLocationManagerDelegate
// Вынесен в extension без @MainActor — delegate вызывается из фонового потока

extension PickupMapViewModel: CLLocationManagerDelegate {

    nonisolated func locationManager(_ manager: CLLocationManager,
                                     didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }
        let coord = loc.coordinate
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.userLocation = coord
            self.region = MKCoordinateRegion(
                center: coord,
                span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
            )
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager,
                                     didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.locationAuthStatus = status
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                manager.requestLocation()
            }
        }
    }
}
