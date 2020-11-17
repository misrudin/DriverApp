//
//  RegisterModel.swift
//  DriverApp
//
//  Created by Indo Office4 on 17/11/20.
//

import Foundation

struct Gender: Codable {
    let name: String
}

struct Language: Codable {
    let name: String
}

struct VehicleYear {
    let year: String
}


struct RegisterData: Codable {
    let user_image: String
    let first_name: String
    let last_name: String
    let date_of_birth: String
    let postal_code: String
    let prefectures: String
    let municipal_district: String
    let chome: String
    let municipality_kana: String
    let kana_after_address: String
    let gender: String
    let language: String
    let phone_number: String
    let email: String
    let password: String
    let license_number: String
    let license_expired_date: String
    let insurance_company: String
    let personal_coverage: String
    let compensation_range_object: String
    let insurance_expired_date: String
    let vehicle_name: String
    let vehicle_year: String
    let vehicle_ownership: String
    let vehicle_certificate_exp: String
    let vehicle_certification_photo: String
    let vehicle_photo_1: String
    let vehicle_photo_2: String
    let vehicle_photo_3: String
    let date_add: String
}
