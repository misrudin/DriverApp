//
//  RegisterViewModel.swift
//  DriverApp
//
//  Created by Indo Office4 on 17/11/20.
//

import Foundation
import UIKit

struct RegisterViewModel {
    func cekValidation(data: RegisterData, completion: @escaping (Result<Bool, Error>)-> Void){
        if data.user_image == "" {
            completion(.failure(ErrorRegister.userFoto))
            return
        }
        if data.first_name == "" {
            completion(.failure(ErrorRegister.firstName))
            return
        }
        
        if data.last_name == "" {
            completion(.failure(ErrorRegister.lastName))
            return
        }
        
        if data.date_of_birth == "" {
            completion(.failure(ErrorRegister.dateOfBirth))
            return
        }
        
        if data.postal_code == "" {
            completion(.failure(ErrorRegister.postalCode))
            return
        }
        
        if data.prefectures == "" {
            completion(.failure(ErrorRegister.prefectures))
            return
        }
        
        if data.municipal_district == "" {
            completion(.failure(ErrorRegister.municipalDistrict))
            return
        }
        
        if data.chome == "" {
            completion(.failure(ErrorRegister.chome))
            return
        }
        
        if data.municipality_kana == "" {
            completion(.failure(ErrorRegister.municipalityKana))
            return
        }
        
        if data.kana_after_address == "" {
            completion(.failure(ErrorRegister.KanaAfterAddress))
            return
        }
        
        if data.gender == "" {
            completion(.failure(ErrorRegister.gender))
            return
        }
        
        if data.language == "" {
            completion(.failure(ErrorRegister.language))
            return
        }
        
        if data.phone_number == "" {
            completion(.failure(ErrorRegister.phoneNumber))
            return
        }
        
        if data.email == "" {
            completion(.failure(ErrorRegister.email))
            return
        }
        
        if data.password == "" {
            completion(.failure(ErrorRegister.password))
            return
        }
        
        if data.license_number == "" {
            completion(.failure(ErrorRegister.licensseNumber))
            return
        }
        
        if data.license_expired_date == "" {
            completion(.failure(ErrorRegister.licenseExpDate))
            return
        }
        
        if data.insurance_company == "" {
            completion(.failure(ErrorRegister.insuranceCompany))
            return
        }
        
        if data.personal_coverage == "" {
            completion(.failure(ErrorRegister.personalCoverage))
            return
        }
        
        if data.compensation_range_object == "" {
            completion(.failure(ErrorRegister.compRangeObj))
            return
        }
        
        if data.insurance_expired_date == "" {
            completion(.failure(ErrorRegister.insuranceExpDate))
            return
        }
        
        if data.vehicle_name == "" {
            completion(.failure(ErrorRegister.vehicleName))
            return
        }
        
        if data.vehicle_year == "" {
            completion(.failure(ErrorRegister.vehicleYear))
            return
        }
        
        if data.vehicle_ownership == "" {
            completion(.failure(ErrorRegister.vehicleOwnership))
            return
        }
        
        if data.vehicle_certificate_exp == "" {
            completion(.failure(ErrorRegister.vehicleCerExp))
            return
        }
        
        if data.vehicle_certification_photo == "" {
            completion(.failure(ErrorRegister.vehicleCerPhoto))
            return
        }
        
        if data.vehicle_photo_1 == "" {
            completion(.failure(ErrorRegister.vehiclePhoto1))
            return
        }
        
        if data.vehicle_photo_2 == "" {
            completion(.failure(ErrorRegister.vehiclePhoto2))
            return
        }
        
        if data.vehicle_photo_3 == "" {
            completion(.failure(ErrorRegister.vehiclePhoto3))
            return
        }
        
        completion(.success(true))
        
    }
}

enum ErrorRegister: Error {
    case userFoto
    case firstName
    case lastName
    case dateOfBirth
    case postalCode
    case prefectures
    case municipalDistrict
    case chome
    case municipalityKana
    case KanaAfterAddress
    case gender
    case language
    case phoneNumber
    case email
    case password
    case licensseNumber
    case licenseExpDate
    case insuranceCompany
    case personalCoverage
    case compRangeObj
    case insuranceExpDate
    case vehicleName
    case vehicleYear
    case vehicleOwnership
    case vehicleCerExp
    case vehicleCerPhoto
    case vehiclePhoto1
    case vehiclePhoto2
    case vehiclePhoto3
}
