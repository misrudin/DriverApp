//
//  ChatModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 24/10/20.
//

import Foundation

struct Message:Codable {
    let chatContent: String
    let chatDate: String
    let sendBy: String
    let chatTime: String
}


struct ChatMessage:Codable {
    let text: String?
    let isIncoming: Bool
    let date: Date
    let time: String
    let photo: String?
}


struct HistoryMessage: Codable {
    let lastContentChat: String
    let lastFileSend: String
    let lastChatDate: String
    let codeDriver: String
}


struct Admin: Decodable {
    let email: String?
    let employee_number: String
    let group_name: String
    let iduser: Int
    let first_name: String
    let last_name: String
    let photo_name: String?
    let photo_url: String?
}

struct DataAdmin: Decodable {
    let data: [Admin]
}
