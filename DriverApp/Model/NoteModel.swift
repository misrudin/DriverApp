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
    
    enum CodingKeys: String, CodingKey {
        case note = "note"
    }
}

struct NotesCheckout: Decodable {
    let data: [Checkout]
    let totalData: Int
    let totalPage: Int
    
    enum CodingKeys: String, CodingKey {
        case data
        case totalData
        case totalPage
    }
}


struct Checkout: Decodable {
    let note: String
    let idNote: Int 
    let createdDate: String
    let createdTime: String
    
    enum CodingKeys: String, CodingKey {
        case note = "note"
        case idNote = "id_note_driver_chcekout"
        case createdDate = "created_date"
        case createdTime = "created_time"
    }
}
