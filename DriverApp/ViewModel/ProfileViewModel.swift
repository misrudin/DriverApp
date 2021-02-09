//
//  ProfileViewModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 16/10/20.
//

import Foundation
import Alamofire
import SwiftyJSON
import FirebaseDatabase
import AesEverywhere
import LanguageManager_iOS

struct ProfileViewModel {
    var delegate: ProfileViewModelDelegate?
    private let database = Database.database().reference()
    
    func cekStatusDriver(codeDriver:String, completion: @escaping (Result<UserStatus, Error>)-> Void){
        let date = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        
        let dateNow: String = dateFormater.string(from: date)
        let urlFirebase = "monitoring/\(dateNow)/\(codeDriver)"
        
        database.child(urlFirebase).observe(.value) { (snapshot) in
            guard let data = snapshot.value as? [String: Any] else{
                            completion(.failure(DataError.failedToFetch))
                            return
                        }
            
            let checkinTime = data["checkin_time"] as? String
            let restTime = data["rest_time"] as? String
            let workTime = data["work_time"] as? String
            let checkoutTime = data["checkout_time"] as? String
            let currentOrder = data["current_order"] as? String
            let statusOrder = data["order_status"] as? String
            let userStatus: UserStatus = UserStatus(checkinTime: checkinTime,
                                                    checkoutTime: checkoutTime,
                                                    restTime: restTime,
                                                    workTime: workTime,
                                                    currentOrder: currentOrder, statusOrder: statusOrder)
            debugPrint(data)
            completion(.success(userStatus))
        }
    }
    
    //MARK: - Get detail user
    func getDetailUser(with codeDriver: String)->Void{
        AF.request("\(Base.urlDriver)detail/\(codeDriver)",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                
                if response.response?.statusCode == 200 {
                    if let data = response.data {
                        guard let userData =  parseJson(data: data), let bioData = decodeBio(data: userData.bio, codeDriver: userData.code_driver), let vehicleData = decodeVehicle(data: userData.vehicle, codeDriver: userData.code_driver) else {
                            delegate?.didFailedToFetch(ErrorDriver.failedToDecode)
                            return }
                        
                            delegate?.didFetchUser(self, user: userData, bio: bioData, vehicle: vehicleData)
                        }
                }else {
                    delegate?.didFailedToFetch(ErrorDriver.failedToFetch)
                }
                
                
            case let .failure(error):
                delegate?.didFailedToFetch(error)
            }
        }
    }
    
    
    //MARK: - Chenge password
    func changePassword(data: PasswordModel, completion: @escaping (Result<Bool,Error>)-> Void){
        AF.request("\(Base.urlDriver)edit/password",
                   method: .patch,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            completion(.success(true))
                        }else {
                            if let data = response.data {
                                if let res = parseResponse(data: data){
                                    completion(.failure(DataError.failedToEditPassword(message: res.Message_JP)))
                                }
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                   })
    }
    
    private func parseResponse(data: Data)-> ResponseData?{
    do{
        let decodedData = try JSONDecoder().decode(ResponseData.self, from: data)
        return decodedData
    }catch{
        return nil
    }
    }
    
    //MARK: - update photo
    func updateFoto(data: String, codeDriver: String, completion: @escaping (Result<Bool,Error>)-> Void){
        let data = Foto(photo: data, code_driver: codeDriver)
        
        AF.request("\(Base.url)livetracking/driver/edit/photo",
                   method: .patch,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    
                    switch response.result {
                    case .success:
                        completion(.success(true))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
        })
    }
    
    
    //MARK: - update bio
    func updateProfile(data: UpdatePersonal, completion: @escaping (Result<Bool,Error>)-> Void){
        AF.request("\(Base.urlDriver)edit/personal",
                   method: .patch,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    
                    switch response.result {
                    case .success:
                        completion(.success(true))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
        })
    }
    
    //MARK: - Encryp bio
    func encryptBio(data: PersonalData, codeDriver: String)-> String? {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(data), let dataString = String(data: jsonData, encoding: .utf8) {
            let crypted = try! AES256.encrypt(input: dataString, passphrase: codeDriver)
            return crypted
        }
        return nil
    }
    
    //MARK: - update email
    
    func updateEmail(data: UpdateEmail, completion: @escaping (Result<Bool,Error>)-> Void){
        AF.request("\(Base.urlDriver)edit/email",
                   method: .patch,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    
                    switch response.result {
                    case .success:
                        completion(.success(true))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
        })
    }
    
    func validateEdit(data: VehicleEdit, completion: @escaping (Result<Bool, Error>)-> Void){
        
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
        
        if Validation().isValidEmail(data.email) != true {
            completion(.failure(ErrorRegister.emailNotValid))
            return
        }
        
        if data.insurance_company_name == "" {
            completion(.failure(DataError.insurance_company_name))
        }
        
        if data.coverage_personal == "" {
            completion(.failure(DataError.coverage_personal))
        }
        
        if data.compensation_range_objective == "" {
            completion(.failure(DataError.compensation_range_objective))
        }
        
        if data.insurance_expiration_date == "" {
            completion(.failure(DataError.insurance_expiration_date))
        }
        
        if data.vehicle_name == "" {
            completion(.failure(DataError.vehicle_name))
        }
        
        if data.vehicle_number_plate == "" {
            completion(.failure(DataError.vehicle_number_plate))
        }
        
        if data.vehicle_year == "" {
            completion(.failure(DataError.vehicle_year))
        }
        
        if data.vehicle_ownership == "" {
            completion(.failure(DataError.vehicle_ownership))
        }
        
        if data.vehicle_inspection_certificate_expiration_date == "" {
            completion(.failure(DataError.vehicle_inspection_certificate_expiration_date))
        }
    }
    
    func editVehicleData(data: VehicleEditData, completion: @escaping (Result<Bool, Error>)-> Void){
        AF.request("\(Base.urlDriver)validate/vehicle",
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
                                        completion(.failure(OrderError.failedToFetch(re.Message_JP)))
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
    
    
    //MARK:-   Decode data
    func decodeBio(data: String, codeDriver: String)-> Bio? {
            let decrypted = try! AES256.decrypt(input: data, passphrase: codeDriver)
            let data = Data(decrypted.utf8)
            let bioData = parseBio(data: data)
            return bioData
        }
    
    
    func decodeVehicle(data: String, codeDriver: String)-> VehicleData? {
            let decrypted = try! AES256.decrypt(input: data, passphrase: codeDriver)
            let data = Data(decrypted.utf8)
            let vehicleData = parseVehicle(data: data)
            return vehicleData
        }
    
    //MARK:-    Parese data
    func parseJson(data: Data) -> UserModel?{
        do{
            let decodedData = try JSONDecoder().decode(DataUser.self, from: data)
            return decodedData.data
        }catch{
            delegate?.didFailedToFetch(error)
            return nil
        }
    }
    
    func parseResult(data: Data) -> ResultData?{
        do{
            let decodedData = try JSONDecoder().decode(ResultData.self, from: data)
            return decodedData
        }catch{
            return nil
        }
    }
    
    func parseBio(data: Data) -> Bio?{
        do{
            let decodedData = try JSONDecoder().decode(Bio.self, from: data)
            return decodedData
        }catch{
            delegate?.didFailedToFetch(error)
            return nil
        }
    }
    
    func parseVehicle(data: Data) -> VehicleData?{
        do{
            let decodedData = try JSONDecoder().decode(VehicleData.self, from: data)
            return decodedData
        }catch{
            delegate?.didFailedToFetch(error)
            return nil
        }
    }
    
}


//    MARK: - enum
enum DataError: Error{
    case failedToFetch
    case failedToCheckout
    
    case vehicle_name
    case vehicle_number_plate
    case vehicle_year
    case vehicle_ownership
    case vehicle_inspection_certificate_expiration_date
    case insurance_company_name
    case coverage_personal
    case compensation_range_objective
    case insurance_expiration_date
    
    case failedToEdit
    case failedToEditPassword(message: String)
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToFetch:
            return NSLocalizedString(
                "Failed to fetch data !".localiz(),
                comment: ""
            )
        case .failedToCheckout:
            return NSLocalizedString(
                "Failed to checkout !".localiz(),
                comment: ""
            )
        case .vehicle_name:
            return NSLocalizedString(
                "Vehicle name must be entered !".localiz(),
                comment: ""
            )
        case .vehicle_number_plate:
            return NSLocalizedString(
                "Vehicle number plate must be entered !".localiz(),
                comment: ""
            )
        case .vehicle_year:
            return NSLocalizedString(
                "Vehicle year must be entered !".localiz(),
                comment: ""
            )
        case .vehicle_ownership:
            return NSLocalizedString(
                "Vehicle ownership must be entered !".localiz(),
                comment: ""
            )
        case .vehicle_inspection_certificate_expiration_date:
            return NSLocalizedString(
                "Vehicle inspection certificate expiration date must be entered !".localiz(),
                comment: ""
            )
        case .insurance_company_name:
            return NSLocalizedString(
                "Insurance company name must be entered !".localiz(),
                comment: ""
            )
        case .coverage_personal:
            return NSLocalizedString(
                "Coverage personal must be entered !".localiz(),
                comment: ""
            )
        case .compensation_range_objective:
            return NSLocalizedString(
                "Compensation range must be entered !".localiz(),
                comment: ""
            )
        case .insurance_expiration_date:
            return NSLocalizedString(
                "Insurance expiration date must be entered !".localiz(),
                comment: ""
            )
        case .failedToEdit:
            return NSLocalizedString(
                "Failed to edit data !".localiz(),
                comment: ""
            )
        case .failedToEditPassword(let message):
                return NSLocalizedString(
                    message,
                    comment: ""
                )
        }
    }
}
