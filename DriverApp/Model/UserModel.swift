//
//  UserModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 16/10/20.
//

import Foundation

struct UserModel: Decodable {
    let idDriver: Int
    let codeDriver: String
    let firstName: String
    let lastName: String
    let email: String
    let countryCode: String
    let mobileNumber1: String
    let mobileNumber2: String
    let mobileNumber3: String
    let photoUrl: String
    let photoName: String

    enum CodingKeys: String, CodingKey {
        case idDriver = "id_driver"
        case codeDriver = "code_driver"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case countryCode = "country_code"
        case mobileNumber1 = "mobile_number1"
        case mobileNumber2 = "mobile_number2"
        case mobileNumber3 = "mobile_number3"
        case photoUrl = "photo_url"
        case photoName = "photo_name"
    }
}

struct DataUser: Decodable {
    let data: UserModel

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}


struct PasswordModel: Codable {
    let code_driver: String
    let old_password: String
    let password: String
}


struct ResultData: Codable {
    let message: String
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case status = "Status"
    }
}


struct Foto: Codable {
    let photo: String
    let code_driver: String
}

struct FotoData: Codable {
    let photoUrl: String
    let photoName: String
}

struct DataProfile: Codable {
    let id_driver: Int
    let first_name: String
    let last_name: String
    let mobile_number1: String
    let mobile_number2: String
    let mobile_number3: String
    let country_code: String
    let email: String
}


struct UserStatus: Codable {
    let checkinTime: String?
    let checkoutTime: String?
    let restTime: String?
    let workTime: String?
}
