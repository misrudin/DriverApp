//
//  RegisterViewModel.swift
//  DriverApp
//
//  Created by Indo Office4 on 17/11/20.
//

import Foundation
import UIKit
import FirebaseDatabase
import Alamofire
import LanguageManager_iOS

struct RegisterViewModel {
//    private let database = Database.database().reference()
    
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
        
        if data.first_name_hiragana == "" {
            completion(.failure(ErrorRegister.firstNameHiragana))
            return
        }
        
        if data.last_name_hiragana == "" {
            completion(.failure(ErrorRegister.lastNameHiragana))
            return
        }
        
        if data.date_of_birth == "" {
            completion(.failure(ErrorRegister.dateOfBirth))
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
        
        if Validation().isValidEmail(data.email) != true {
            completion(.failure(ErrorRegister.emailNotValid))
            return
        }
        
        if data.password == "" {
            completion(.failure(ErrorRegister.password))
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
        
        if data.vehicle_number_plate == "" {
            completion(.failure(ErrorRegister.vehiclePlate))
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
    
    //MARK: - Register function
    func register(data: RegisterData, completion: @escaping (Result<Bool, Error>)->Void){
        AF.request("\(Base.urlDriver)validate/register",
                   method: .post,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).response(completionHandler: {(response) in
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        if let statusCode = response.response?.statusCode {
                            if statusCode != 200 {
                                if let data = response.data {
                                    if let re = Helpers().decodeError(data: data){
                                        completion(.failure(OrderError.failedToFetch(re.Message)))
                                    }
                                }
                            }else {
                                completion(.success(true))
                            }
                        }
                        
                    case.failure(_):
                        completion(.failure(ErrorDriver.failedToFetch))
                    }
                    
            })
    }
}

enum ErrorRegister: Error {
    case userFoto
    case firstName
    case lastName
    case firstNameHiragana
    case lastNameHiragana
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
    case emailNotValid
    case vehiclePlate
}

extension ErrorRegister: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .userFoto:
            return NSLocalizedString(
                "Please select profile picture !".localiz(),
                comment: ""
            )
        case .firstName:
            return NSLocalizedString(
                "First name must be entered !".localiz(),
                comment: ""
            )
        case .lastName:
            return NSLocalizedString(
                "Last name must be entered !".localiz(),
                comment: ""
            )
        case .firstNameHiragana:
            return NSLocalizedString(
                "First name hiragana must be entered !".localiz(),
                comment: ""
            )
        case .lastNameHiragana:
            return NSLocalizedString(
                "Last name hiragana must be entered !".localiz(),
                comment: ""
            )
        case .dateOfBirth:
            return NSLocalizedString(
                "Birth date must be entered !".localiz(),
                comment: ""
            )
        case .postalCode:
            return NSLocalizedString(
                "Postal code must be entered !".localiz(),
                comment: ""
            )
        case .prefectures:
            return NSLocalizedString(
                "Birth date must be entered !".localiz(),
                comment: ""
            )
        case .municipalDistrict:
            return NSLocalizedString(
                "Municipal district must be entered !".localiz(),
                comment: ""
            )
        case .chome:
            return NSLocalizedString(
                "Chome address must be entered !".localiz(),
                comment: ""
            )
        case .municipalityKana:
            return NSLocalizedString(
                "Municipality kana must be entered !".localiz(),
                comment: ""
            )
        case .KanaAfterAddress:
            return NSLocalizedString(
                "Kana after address must be entered !".localiz(),
                comment: ""
            )
        case .gender:
            return NSLocalizedString(
                "Gender must be entered !".localiz(),
                comment: ""
            )
        case .language:
            return NSLocalizedString(
                "Language must be entered !".localiz(),
                comment: ""
            )
        case .phoneNumber:
            return NSLocalizedString(
                "Phone number must be entered !".localiz(),
                comment: ""
            )
        case .email:
            return NSLocalizedString(
                "Email must be entered !".localiz(),
                comment: ""
            )
        case .password:
            return NSLocalizedString(
                "Password must be entered !".localiz(),
                comment: ""
            )
        case .licensseNumber:
            return NSLocalizedString(
                "License number must be entered !".localiz(),
                comment: ""
            )
        case .licenseExpDate:
            return NSLocalizedString(
                "License expiration date must be entered !".localiz(),
                comment: ""
            )
        case .insuranceCompany:
            return NSLocalizedString(
                "Insurance company must be entered !".localiz(),
                comment: ""
            )
        case .personalCoverage:
            return NSLocalizedString(
                "Personal coverage must be entered !".localiz(),
                comment: ""
            )
        case .compRangeObj:
            return NSLocalizedString(
                "Compention range object must be entered !".localiz(),
                comment: ""
            )
        case .insuranceExpDate:
            return NSLocalizedString(
                "Insurance expiration date must be entered !".localiz(),
                comment: ""
            )
        case .vehicleName:
            return NSLocalizedString(
                "Vehicle name must be entered !".localiz(),
                comment: ""
            )
        case .vehicleYear:
            return NSLocalizedString(
                "Vehicle year must be entered !".localiz(),
                comment: ""
            )
        case .vehicleOwnership:
            return NSLocalizedString(
                "Vehicle ownership must be entered !".localiz(),
                comment: ""
            )
        case .vehicleCerExp:
            return NSLocalizedString(
                "Vehicle certification expiration must be entered !".localiz(),
                comment: ""
            )
        case .vehicleCerPhoto:
            return NSLocalizedString(
                "Vehicle certification photo must be entered !".localiz(),
                comment: ""
            )
        case .vehiclePhoto1:
            return NSLocalizedString(
                "Vehicle photo must be entered !".localiz(),
                comment: ""
            )
        case .vehiclePhoto2:
            return NSLocalizedString(
                "Vehicle photo must be entered !".localiz(),
                comment: ""
            )
        case .vehiclePhoto3:
            return NSLocalizedString(
                "Vehicle photo must be entered !".localiz(),
                comment: ""
            )
        case .failedToRegister:
            return NSLocalizedString(
                "Register failed !".localiz(),
                comment: ""
            )
        case .emailNotValid:
            return NSLocalizedString(
                "Please use a valid email !".localiz(),
                comment: ""
            )
        case .vehiclePlate:
            return NSLocalizedString(
                "Vehicle plate must be entered !".localiz(),
                comment: ""
            )
        }
    }
}


//push data
//        let urlFirebase = "registration"
//        let dataToPost:[String: Any] = [
//            "photo" : data.photo,
//            "first_name" : data.first_name,
//            "last_name" : data.last_name,
//            "first_name_hiragana" : data.first_name_hisragana,
//            "last_name_hiragana" : data.last_name_hiragana,
//            "birthday_date" : data.birthday_date,
//            "postal_code" : data.postal_code,
//            "prefecture" : data.prefecture,
//            "municipal_district" : data.municipal_district,
//            "chome" : data.chome,
//            "municipality_kana" : data.municipality_kana,
//            "kana_after_address" : data.kana_after_address,
//            "sex" : data.sex.lowercased(),
//            "language" : data.language.lowercased(),
//            "phone_number" : data.phone_number,
//            "email" : data.email,
//            "password" : data.password,
//            "driver_license_number" : data.driver_license_number,
//            "driver_license_expired_date" : data.driver_license_expired_date,
//            "insurance_company_name" : data.insurance_company_name,
//            "coverage_personal" : data.coverage_personal,
//            "compensation_range_objective" : data.compensation_range_objective,
//            "insurance_expiration_date" : data.insurance_expiration_date,
//            "vehicle_name" : data.vehicle_name,
//            "vehicle_number_plate": data.vehicle_number_plate,
//            "vehicle_year" : data.vehicle_year,
//            "vehicle_ownership" : data.vehicle_ownership,
//            "vehicle_inspection_certificate_expiration_date" : data.vehicle_inspection_certificate_expiration_date,
//            "vehicle_inspection_certificate_photo" : data.vehicle_inspection_certificate_photo,
//            "vehicle_photo_1" : data.vehicle_photo_1,
//            "vehicle_photo_2" : data.vehicle_photo_2,
//            "vehicle_photo_3" : data.vehicle_photo_3,
//            "date_add" : data.date_add
//        ]
//
//        database.child(urlFirebase).childByAutoId().setValue(dataToPost) { (error, _) in
//            guard error == nil else {
//                completion(.failure(ErrorRegister.failedToRegister))
//                return
//            }
//            completion(.success(true))
//        }
