//
//  Base.swift
//  DriverApp
//
//  Created by Indo Office4 on 10/11/20.
//

import Foundation
import Alamofire

struct Base {
    static let url: String = "https://mobileapiapp.azure-api.net/api/"
    static let urlDriver: String = "https://mobileapiapp.azure-api.net/api/driver/"
    static let urlOrder: String = "https://mobileapiapp.azure-api.net/api/order/"
    static let headers: HTTPHeaders = [
            "token": "775db6e86a9440df9cbbd75780403eae",
            "Accept": "application/json"
    ]
    static let paswordEncKey = "a421a5080c9738e13f75941b6a0574c1e256ab5c2ac0988fcfe3b6dd9837d53ed280471be0fe462ddeb5856468d6d17da0d8175ddb641e5777cad887db195d0d"
    static let mapsApiKey = "AIzaSyCd86hl5oFNB9zwVFZ2YXJy4EYx_oWgD54"
    
    static let baseUrlResetPassword: String =
        "https://usmh-user-livetracking.azurewebsites.net/reset-password"
}


struct ResponseData: Codable {
    let Message: String

    enum CodeingKeys: String, CodingKey{
        case Message
    }
}
