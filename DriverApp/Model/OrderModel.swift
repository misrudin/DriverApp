//
//  OrderModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 18/10/20.
//

import Foundation
import CoreLocation

struct HistoryData: Decodable {
    let data: [History]
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct History: Decodable {
    let code_driver: String
    let id_shift_time: Int
    let active_date: String
    let user_info: String
    let status_tracking: String
    let id_order: Int
    let order_detail: String
    let order_number: String
    let time_detail: TimeDetail
    let status_rating: Bool
    let rating: Double
    let comment: String?
        
    enum CodingKeys: String, CodingKey {
        case code_driver
        case id_shift_time
        case active_date
        case user_info
        case status_tracking
        case id_order
        case order_detail
        case order_number
        case time_detail
        case status_rating
        case rating
        case comment
    }
}



struct TimeDetail: Decodable {
    let time_start_pickup: String?
    let date_start_pickup: String?
    let time_done_pickup: String?
    let date_done_pickup: String?
    let time_done_delivery: String?
    let time_start_delivery: String?
    let date_done_delivery: String?
    let date_start_delivery: String?
    
    enum CodingKeys: String, CodingKey {
        case time_start_pickup
        case date_start_pickup
        case time_done_pickup
        case date_done_pickup
        case time_done_delivery
        case time_start_delivery
        case date_done_delivery
        case date_start_delivery
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
    let id_group: Int
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
    var order_list: [NewOrderData]?
    
    enum CodingKeys: String, CodingKey {
        case date
        case order_list
    }
}

//before decript
struct NewOrderData: Decodable {
    let user_info: String
    let detail_shift: DetailShift
    let order_detail: String
    let status_tracking: String
    let order_number: String
    let code_driver: String
    let active_date: String
    let id_order: Int
    let id_shift_time: Int
    let another_pickup: [AnotherPickup]?
    let pending_by_system: Bool?
    
    enum CodingKeys: String, CodingKey {
        case user_info
        case order_detail
        case status_tracking
        case order_number
        case code_driver
        case active_date
        case id_order
        case id_shift_time
        case detail_shift
        case another_pickup
        case pending_by_system
    }
}

//another pickup
struct AnotherPickup: Decodable {
    let pickup_store_name: String
    var pickup_list: [PickupList]?
}

//pickup list
struct PickupList: Decodable {
    let order_no: String
    var pickup_item: [PickupItem]?
}

//detail shift
struct DetailShift: Decodable {
    let time_start_shift: String
    let label_data: String
    let time_end_shift: String
}


//user info decript
struct NewUserInfo: Decodable {
    let first_name: String
    let last_name: String
    let address: String
    let phone_number: String
    
    enum CodingKeys: String, CodingKey {
        case first_name
        case last_name
        case address
        case phone_number
    }
}


//order detail decript
struct NewOrderDetail: Decodable {
    let delivery_destination: DeliveryDestination
    let pickup_destination: [PickupDestination]
    let classification: String?
    
    enum CodingKeys: String, CodingKey {
        case delivery_destination
        case pickup_destination
        case classification
    }
}


//delivery destination
struct DeliveryDestination: Decodable {
    let lat: String?
    let long: String?
    
    enum CodingKeys: String, CodingKey {
        case lat
        case long
    }
}


//pickup destination
struct PickupDestination: Decodable {
    let pickup_store_name: String
    let lat: String?
    let long: String?
    var pickup_item: [PickupItem]
    
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
    var scan: Bool?
    
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
    var scanned_status: Int
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


//MARK: - Response Reject
struct ResponseReject: Decodable {
    let data: Int
}


struct NewOrderList: Decodable {
    let data: NewDataOrder?
}

struct NewDataOrder: Decodable {
    let pickup_list: [Pickup]?
    let delivery_list: [NewDelivery]?
}


struct Pickup: Decodable {
    let pickup_store_name: String
    let store_address: String
    let lat: String
    let long: String
    let pickup_item: [PickupItem]?
    let order_number: String
    let classification: String?
    let status_tracking: String
    let active_date: String
    let queue: Int
    let distance: Double
    let pending_by_system: Bool
    let id_shift_time: Int
}

struct NewDelivery: Decodable {
    let order_number: String
    let id_shift_time: Int
    let status_tracking: String
    let active_date: String
    let id_group: Int
    let pending_by_system: Bool
    let classification: String?
    let lat: String
    let long: String
    let queue: Int
    let distance: Double
    let user_info: String?
    let pickup_item: [DeliveryPickupItem]?
}


struct DeliveryPickupItem: Decodable {
    let pickup_store_name: String
    let pickup_item: [PickupItem]?
}
