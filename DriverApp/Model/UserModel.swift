//
//  UserModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 16/10/20.
//

import Foundation

struct UserModel: Decodable {
    let id_driver: Int
    let code_driver: String
    let join_date: String
    let join_time: String
    let email: String
    let working_status: String
    let bio: String
    let vehicle: String

    enum CodingKeys: String, CodingKey {
        case id_driver
        case code_driver
        case join_date
        case join_time
        case email
        case working_status
        case bio
        case vehicle
    }
}

struct Bio: Decodable {
    let phone_number: String
    let first_name: String
    let last_name: String
    let birthday_date: String
    let postal_code: String
    let prefecture: String
    let municipal_district: String
    let chome: String
    let municipality_kana: String
    let kana_after_address: String
    let sex: String
    let driver_license_number: String
    let driver_license_expiration_date: String
    let photo_url: String
    let photo_name: String
    
    enum CodingKeys: String, CodingKey {
        case phone_number
        case first_name
        case last_name
        case birthday_date
        case postal_code
        case prefecture
        case municipal_district
        case chome
        case municipality_kana
        case kana_after_address
        case sex
        case driver_license_number
        case driver_license_expiration_date
        case photo_url
        case photo_name
    }
}

struct VehicleData: Decodable {
    let vehicle_name: String
    let vehicle_number_plate: String
    let vehicle_year: String
    let vehicle_ownership: String
    let vehicle_inspection_certificate_expiration_date: String
    let insurance_company_name: String
    let coverage_personal: String
    let compensation_range_objective: String
    let insurance_expiration_date: String
    let vehicle_inspection_certificate_photo_url: String
    let vehicle_inspection_certificate_photo_name: String
    let vehicle_photo_data: [VehiclePhotoData]
    
    enum CodingKeys: String, CodingKey {
        case vehicle_name
        case vehicle_number_plate
        case vehicle_year
        case vehicle_ownership
        case vehicle_inspection_certificate_expiration_date
        case insurance_company_name
        case coverage_personal
        case compensation_range_objective
        case insurance_expiration_date
        case vehicle_inspection_certificate_photo_url
        case vehicle_inspection_certificate_photo_name
        case vehicle_photo_data
    }
    
}

struct VehiclePhotoData: Decodable {
    let vehicle_photo_url: String
    let vehicle_photo_name: String
    
    enum CodingKeys: String, CodingKey {
        case vehicle_photo_url
        case vehicle_photo_name
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


struct CheckoutDriver: Codable {
    let id_driver: Int
}


struct VehicleEdit: Codable {
    let code_driver: String
    let vehicle_name: String
    let vehicle_number_plate: String
    let vehicle_year: String
    let vehicle_ownership: String
    let vehicle_inspection_certificate_expiration_date: String
    let insurance_company_name: String
    let coverage_personal: String
    let compensation_range_objective: String
    let insurance_expiration_date: String
}
