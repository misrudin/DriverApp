//
//  Response.swift
//  DriverApp
//
//  Created by Indo Office4 on 21/12/20.
//

import Foundation

struct ErrorResponse: Decodable {
    let Status: Int
    let Message: String
    let Message_JP: String
    
    enum CodingKeys: String, CodingKey {
        case Status
        case Message
        case Message_JP
    }
}
