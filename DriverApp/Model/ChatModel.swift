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
    let text: String
    let isIncoming: Bool
    let date: Date
    let time: String
}


struct HistoryMessage: Codable {
    let lastContentChat: String
    let lastFileSend: String
    let lastChatDate: String
    let codeDriver: String
    let token: String
}
