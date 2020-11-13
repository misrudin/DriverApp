//
//  InOutModel.swift
//  DriverApp
//
//  Created by Indo Office4 on 13/11/20.
//

import Foundation

struct CheckinData: Codable {
    let id_driver: Int
    let lat: String
    let long: String
}

struct DataParentStatus: Decodable {
    let data: StatusInOutDriver
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct StatusInOutDriver: Decodable {
    let isCheckin: Bool
    let isCheckout: Bool
    
    enum CodingKeys: String, CodingKey {
        case isCheckin = "checkin"
        case isCheckout = "checkout"
    }
}


struct CheckDriver: Codable {
    let id_driver: Int
}
