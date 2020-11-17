//
//  RegisterViewModel.swift
//  DriverApp
//
//  Created by Indo Office4 on 17/11/20.
//

import Foundation
import UIKit
import FirebaseDatabase

struct RegisterViewModel {
    private let database = Database.database().reference()
    
    func cekValidation(data: RegisterDataTemp, completion: @escaping (Result<Bool, Error>)-> Void){
        
        //MARK: - Personal information
        
        if data.first_name == "" {
            completion(.failure(ErrorRegister.firstName))
            return
        }
        
        if data.last_name == "" {
            completion(.failure(ErrorRegister.lastName))
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
        
        if data.date_of_birth == "" {
            completion(.failure(ErrorRegister.dateOfBirth))
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
        
        //MARK: - Address
        
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
        
        //MARK: - Driver License
        
        if data.license_number == "" {
            completion(.failure(ErrorRegister.licensseNumber))
            return
        }
        
        if data.license_expired_date == "" {
            completion(.failure(ErrorRegister.licenseExpDate))
            return
        }
        
        //MARK: - Vehicle Data
        
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
        
        completion(.success(true))
        
    }
    
    func register(data: RegisterData, completion: @escaping (Result<Bool, Error>)->Void){
        //push data
        let urlFirebase = "registration"
        let dataToPost:[String: Any] = [
            "user_image" : data.user_image,
            "first_name" : data.first_name,
            "last_name" : data.last_name,
            "date_of_birth" : data.date_of_birth,
            "postal_code" : data.postal_code,
            "prefectures" : data.prefectures,
            "municipal_district" : data.municipal_district,
            "chome" : data.chome,
            "municipality_kana" : data.municipality_kana,
            "kana_after_address" : data.kana_after_address,
            "gender" : data.gender,
            "language" : data.language,
            "phone_number" : data.phone_number,
            "email" : data.email,
            "password" : data.password,
            "license_number" : data.license_number,
            "license_expired_date" : data.license_expired_date,
            "insurance_company" : data.insurance_company,
            "personal_coverage" : data.personal_coverage,
            "compensation_range_object" : data.compensation_range_object,
            "insurance_expired_date" : data.insurance_expired_date,
            "vehicle_name" : data.vehicle_name,
            "vehicle_year" : data.vehicle_year,
            "vehicle_ownership" : data.vehicle_ownership,
            "vehicle_certificate_exp" : data.vehicle_certificate_exp,
            "vehicle_certification_photo" : data.vehicle_certification_photo,
            "vehicle_photo_1" : data.vehicle_photo_1,
            "vehicle_photo_2" : data.vehicle_photo_2,
            "vehicle_photo_3" : data.vehicle_photo_3,
            "date_add" : data.date_add
        ]
        
        database.child(urlFirebase).childByAutoId().setValue(dataToPost) { (error, _) in
            guard error == nil else {
                completion(.failure(ErrorRegister.chome))
                return
            }
            completion(.failure(ErrorRegister.failedToRegister))
        }
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
    case failedToRegister
}

extension ErrorRegister: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .userFoto:
            return NSLocalizedString(
                "Please select profile picture !",
                comment: ""
            )
        case .firstName:
            return NSLocalizedString(
                "First name must be entered !",
                comment: ""
            )
        case .lastName:
            return NSLocalizedString(
                "Last name must be entered !",
                comment: ""
            )
        case .dateOfBirth:
            return NSLocalizedString(
                "Birth date must be entered !",
                comment: ""
            )
        case .postalCode:
            return NSLocalizedString(
                "Postal code must be entered !",
                comment: ""
            )
        case .prefectures:
            return NSLocalizedString(
                "Birth date must be entered !",
                comment: ""
            )
        case .municipalDistrict:
            return NSLocalizedString(
                "Municipal district must be entered !",
                comment: ""
            )
        case .chome:
            return NSLocalizedString(
                "Chome address must be entered !",
                comment: ""
            )
        case .municipalityKana:
            return NSLocalizedString(
                "Municipality kana must be entered !",
                comment: ""
            )
        case .KanaAfterAddress:
            return NSLocalizedString(
                "Kana after address must be entered !",
                comment: ""
            )
        case .gender:
            return NSLocalizedString(
                "Gender must be entered !",
                comment: ""
            )
        case .language:
            return NSLocalizedString(
                "Language must be entered !",
                comment: ""
            )
        case .phoneNumber:
            return NSLocalizedString(
                "Phone number must be entered !",
                comment: ""
            )
        case .email:
            return NSLocalizedString(
                "Email must be entered !",
                comment: ""
            )
        case .password:
            return NSLocalizedString(
                "Password must be entered !",
                comment: ""
            )
        case .licensseNumber:
            return NSLocalizedString(
                "License number must be entered !",
                comment: ""
            )
        case .licenseExpDate:
            return NSLocalizedString(
                "License expiration date must be entered !",
                comment: ""
            )
        case .insuranceCompany:
            return NSLocalizedString(
                "Insurance company must be entered !",
                comment: ""
            )
        case .personalCoverage:
            return NSLocalizedString(
                "Personal coverage must be entered !",
                comment: ""
            )
        case .compRangeObj:
            return NSLocalizedString(
                "Compention range object must be entered !",
                comment: ""
            )
        case .insuranceExpDate:
            return NSLocalizedString(
                "Insurance expiration date must be entered !",
                comment: ""
            )
        case .vehicleName:
            return NSLocalizedString(
                "Vehicle name must be entered !",
                comment: ""
            )
        case .vehicleYear:
            return NSLocalizedString(
                "Vehicle year must be entered !",
                comment: ""
            )
        case .vehicleOwnership:
            return NSLocalizedString(
                "Vehicle ownership must be entered !",
                comment: ""
            )
        case .vehicleCerExp:
            return NSLocalizedString(
                "Vehicle certification expiration must be entered !",
                comment: ""
            )
        case .vehicleCerPhoto:
            return NSLocalizedString(
                "Vehicle certification photo must be entered !",
                comment: ""
            )
        case .vehiclePhoto1:
            return NSLocalizedString(
                "Vehicle photo must be entered !",
                comment: ""
            )
        case .vehiclePhoto2:
            return NSLocalizedString(
                "Vehicle photo must be entered !",
                comment: ""
            )
        case .vehiclePhoto3:
            return NSLocalizedString(
                "Vehicle photo must be entered !",
                comment: ""
            )
        case .failedToRegister:
            return NSLocalizedString(
                "Register failed !",
                comment: ""
            )
        }
    }
}
