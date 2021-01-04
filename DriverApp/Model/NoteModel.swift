//
//  NoteModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 23/10/20.
//

import Foundation

struct NotesPending: Codable {
    let data: [Pending]
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct Pending: Codable {
    let note: String
    let idNote: Int
    let createdDate: String
    let createdTime: String
    
    
    enum CodingKeys: String, CodingKey {
        case note = "note"
        case idNote = "id_note"
        case createdDate = "created_date"
        case createdTime = "created_time"
    }
}

//MARK: - Notes

struct Notes: Decodable {
    let data: [Note]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

//MARK: - NOTE
struct Note: Decodable {
    let update_time: String?
    let note_category: String
    let note: String
    let meta_data: MetaData?
    let driver_detail: DriverDetail?
    let update_date: String?
    let created_time: String
    let id_note: Int
    let created_date: String
    let detail_order: NoteOrderDetail
}


struct NoteOrderDetail: Decodable {
    let user_info: String
    let detail_shift: DetailShift
    let status_tracking: String
    let order_number: String
    let order_detail: String
    let another_pickup: [AnotherPickup]?
    let code_driver: String
    let active_date: String
    let id_shift_time: Int
    let id_order: Int
}


//MARK: - Driver Detail
struct DriverDetail: Decodable {
    let working_status: String
    let code_driver: String
    let bio: String
}



//MARK: - update note
struct DataPending: Codable {
    let code_driver: String
    let note: String
    let meta_data: MetaData
}

//MARK: - Meta data
struct MetaData: Codable {
    let order_number: String
    let id_shift_time: Int?
    let status_chat: Bool?
    let status_done: Bool?
    
    enum CodingKeys: String, CodingKey {
        case order_number
        case id_shift_time
        case status_chat
        case status_done
    }
}

//MARK: - update note checkout
struct DataCheckout: Codable {
    let code_driver: String
    let note: String
}


struct DataEditPending:Codable {
    let id_note: Int
    let note: String
}

struct DataEditCheckout:Codable {
    let id_note: Int
    let note: String
}
