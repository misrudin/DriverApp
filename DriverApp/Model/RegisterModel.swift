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
    let photo: String
    let first_name: String
    let last_name: String
    let first_name_hiragana: String
    let last_name_hiragana: String
    let birthday_date: String
    let postal_code: String
    let prefecture: String
    let municipal_district: String
    let chome: String
    let municipality_kana: String
    let kana_after_address: String
    let sex: String
    let language: String
    let phone_number: String
    let email: String
    let password: String
    let driver_license_number: String
    let driver_license_expired_date: String
    let insurance_company_name: String
    let coverage_personal: String
    let compensation_range_objective: String
    let insurance_expiration_date: String
    let vehicle_name: String
    let vehicle_number_plate: String
    let vehicle_year: String
    let vehicle_ownership: String
    let vehicle_inspection_certificate_expiration_date: String
    let vehicle_inspection_certificate_photo: String
    let vehicle_photo_1: String
    let vehicle_photo_2: String
    let vehicle_photo_3: String
    let date_add: String
}

struct RegisterDataTemp: Codable {
    let first_name: String
    let last_name: String
    let first_name_hiragana: String
    let last_name_hiragana: String
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
    let vehicle_number_plate: String
    let vehicle_year: String
    let vehicle_ownership: String
    let vehicle_certificate_exp: String
}


struct VehicleEditData: Codable {
    let code_driver: String
    let vehicle_name: String
    let vehicle_number_plate: String
    let vehicle_year: String
    let vehicle_ownership: String
    let vehicle_inspection_certificate_expiration_date: String
    let vehicle_inspection_certificate_photo: String
    let insurance_company_name: String
    let coverage_personal: String
    let compensation_range_objective: String
    let insurance_expiration_date: String
    let date_edit: String
    let vehicle_photo1: String
    let vehicle_photo2: String
    let vehicle_photo3: String
    let first_name: String
    let last_name: String
    let email: String
}
