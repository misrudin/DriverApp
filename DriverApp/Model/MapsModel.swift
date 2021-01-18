//
//  MapsModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 18/10/20.
//

import Foundation
import CoreLocation

struct DirectionData: Codable {
    let origin: Origin
    let destination: Destination
}

struct Origin: Codable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}

struct Destination: Codable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}

struct DistanceData: Codable {
    let time: String
    let distance: String
}
