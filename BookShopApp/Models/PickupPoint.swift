//
//  PickupPoint.swift
//  BookShopApp
//
//  Created by Maria Shulga on 22/05/2026.
//

import Foundation
import CoreLocation

struct PickupPoint: Identifiable, Equatable {
    let id: Int
    let title: String
    let address: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
