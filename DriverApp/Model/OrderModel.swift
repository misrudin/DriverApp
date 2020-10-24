//
//  OrderModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 18/10/20.
//

import Foundation

struct OrderData: Decodable {
    let data: [Order]
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct OrderDetail: Decodable {
    let data: Order
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct Order: Decodable {
    let idOrder: Int
    let orderNumber: String
    let addressUser: String
    let statusTracking: String
    let latitude: String
    let longitude: String
    let storeDetail: Store
    
    enum CodingKeys: String, CodingKey {
        case idOrder = "id_order"
        case orderNumber = "order_number"
        case addressUser = "address_user"
        case statusTracking = "status_tracking"
        case latitude = "lat"
        case longitude = "long"
        case storeDetail = "store_detail"
    }
}




struct Store: Decodable {
    let storeName: String
    let latitude: String
    let longitude: String
    
    enum CodingKeys: String, CodingKey {
        case storeName = "store_name"
        case latitude = "lat"
        case longitude = "long"
    }
}


struct HistoryData: Decodable {
    let data: [History]
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct History: Decodable {
    let idOrder: Int
    let orderNumber: String
    let addressUser: String
    let statusTracking: String
    let latitude: String
    let longitude: String
    let storeDetail: Store
    let driverDetail: DriverDetail
    let timeDetail: TimeDetail
        
    enum CodingKeys: String, CodingKey {
        case idOrder = "id_order"
        case orderNumber = "order_number"
        case addressUser = "address_user"
        case statusTracking = "status_tracking"
        case latitude = "lat"
        case longitude = "long"
        case storeDetail = "store_detail"
        case driverDetail = "driver_detail"
        case timeDetail = "time_detail"
    }
}


struct DriverDetail: Decodable {
    let codeDriver: String
    let firstName: String
    let lastName: String
    let photoUrl: String
    let photoName: String
    
    enum CodingKeys: String, CodingKey {
        case codeDriver = "code_driver"
        case firstName = "first_name"
        case lastName = "last_name"
        case photoUrl = "photo_url"
        case photoName = "photo_name"
    }
}


struct TimeDetail: Decodable {
    let dateDonePickup: String
    let dateDoneDelivery: String
    let dateStartDelivery: String
    let dateStartPickup: String
    let timeDonePickup: String
    let timeDoneDelivery: String
    let timeStartPickup: String
    let timeStartDelivery: String
    
    enum CodingKeys: String, CodingKey {
        case dateDonePickup = "date_done_pickup"
        case dateDoneDelivery = "date_done_delivery"
        case dateStartDelivery = "date_start_delivery"
        case dateStartPickup = "date_start_pickup"
        case timeDonePickup = "time_done_pickup"
        case timeDoneDelivery = "time_done_delivery"
        case timeStartPickup = "time_start_pickup"
        case timeStartDelivery = "time_start_delivery"
    }
}


struct Delivery: Codable {
    let order_number: String
    let type: String
}
