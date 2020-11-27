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

struct Order: Decodable {
    let idOrder: Int
    let orderNumber: String
    let addressUser: String
    let statusTracking: String
    let latitude: String
    let longitude: String
    let storeDetail: Store
    let idShiftTime: Int
    
    enum CodingKeys: String, CodingKey {
        case idOrder = "id_order"
        case orderNumber = "order_number"
        case addressUser = "address_user"
        case statusTracking = "status_tracking"
        case latitude = "lat"
        case longitude = "long"
        case storeDetail = "store_detail"
        case idShiftTime = "id_shift_time"
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
    let status: String
    let order_number: String
    let type: String
}


struct DeleteHistory: Codable {
    let order_number: String
    let code_driver: String
}


//MARK: - NEW API MODELS

//Parent
struct NewOrder: Decodable {
    let data: [OrderListDate]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct OrderDetail: Decodable {
    let data: NewOrderData
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct OrderListDate: Decodable {
    let date: String
    let order_list: [NewOrderData]?
    
    enum CodingKeys: String, CodingKey {
        case date
        case order_list
    }
}

//before decript
struct NewOrderData: Decodable {
    let user_info: String
    let order_detail: String
    let status_tracking: String
    let order_number: String
    let code_driver: String
    let active_date: String
    let id_order: Int
    let id_shift_time: Int
//    let distance: Double
    
    enum CodingKeys: String, CodingKey {
        case user_info
        case order_detail
        case status_tracking
        case order_number
        case code_driver
        case active_date
        case id_order
        case id_shift_time
//        case distance
    }
}


//user info decript
struct NewUserInfo: Decodable {
    let first_name: String
    let last_name: String
    let postal_code: String
    let prefecture: String
    let chome: String
    let kana_after_address: String
    let address: String
    let phone_number: String
    
    enum CodingKeys: String, CodingKey {
        case first_name
        case last_name
        case postal_code
        case prefecture
        case chome
        case kana_after_address
        case address
        case phone_number
    }
}


//order detail decript
struct NewOrderDetail: Decodable {
    let delivery_destination: DeliveryDestination
    let pickup_destination: [PickupDestination]
    
    enum CodingKeys: String, CodingKey {
        case delivery_destination
        case pickup_destination
    }
}


//delivery destination
struct DeliveryDestination: Decodable {
    let lat: String
    let long: String
    
    enum CodingKeys: String, CodingKey {
        case lat
        case long
    }
}


//pickup destination
struct PickupDestination: Decodable {
    let pickup_store_name: String
    let lat: String
    let long: String
    let pickup_item: [PickupItem]
    
    enum CodingKeys: String, CodingKey {
        case pickup_store_name
        case lat
        case long
        case pickup_item
    }
}



// item pickup
struct PickupItem: Decodable {
    let item_name: String
    let qty: String
    let qr_code_raw: String
    let scan: Bool?
    
    enum CodingKeys: String, CodingKey {
        case item_name
        case qty
        case qr_code_raw
        case scan
    }
}


//MARK: - CEK STATUS SCAN ITEMS data

struct ScanedData: Decodable {
    let data: [Scanned]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct Scanned: Codable {
    let scanned_status: Int
    let qr_code_raw: String
    let order_number: String
    let pickup_store_name: String
    let item_name: String
    
    enum CodingKeys: String, CodingKey {
        case scanned_status
        case qr_code_raw
        case order_number
        case pickup_store_name
        case item_name
    }
}


//MARK: - CHANGE STATUS ITEM SCANNED post/patch

struct Scan: Codable {
    let order_number: String
    let qr_code_raw: [String]
}
