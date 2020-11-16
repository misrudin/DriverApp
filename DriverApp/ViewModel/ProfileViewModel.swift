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
            guard let data = snapshot.value as? [String: String] else{
                            completion(.failure(DataError.failedToFetch))
                            return
                        }
            
            let checkinTime = data["checkin_time"]
            let restTime = data["rest_time"]
            let workTime = data["work_time"]
            let checkoutTime = data["checkout_time"]
            let userStatus: UserStatus = UserStatus(checkinTime: checkinTime,
                                                    checkoutTime: checkoutTime,
                                                    restTime: restTime,
                                                    workTime: workTime)
            completion(.success(userStatus))
        }
    }
    
    func getDetailUser(with codeDriver: String)->Void{
        AF.request("\(Base.url)livetracking/driver/dashboard/detail/\(codeDriver)",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    if let userData =  self.parseJson(data: data){
                        delegate?.didFetchUser(self, user: userData)
                    }
                }
            case let .failure(error):
                delegate?.didFailedToFetch(error)
            }
        }
    }
    
    //    Parese data
    func parseJson(data: Data) -> UserModel?{
        do{
            let decodedData = try JSONDecoder().decode(DataUser.self, from: data)
            return decodedData.data
        }catch{
            delegate?.didFailedToFetch(error)
            return nil
        }
    }
    
    func changePassword(data: PasswordModel, completion: @escaping (Result<ResultData,Error>)-> Void){
        AF.request("\(Base.url)livetracking/driver/edit/password",
                   method: .patch,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    
                    guard let data = response.data else {return}
                    
                    switch response.result {
                    case .success:
                        if let result = parseResult(data: data) {
                            completion(.success(result))
                        }else {
                            completion(.failure(DataError.failedToFetch))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                   })
    }
    
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
    
    func updateProfile(data: DataProfile, completion: @escaping (Result<Bool,Error>)-> Void){
        AF.request("\(Base.url)livetracking/driver/apps/update",
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
    
    
    //    Parese data
    func parseResult(data: Data) -> ResultData?{
        do{
            let decodedData = try JSONDecoder().decode(ResultData.self, from: data)
            return decodedData
        }catch{
            return nil
        }
    }
    
    enum DataError: Error{
        case failedToFetch
        case failedToCheckout
    }
    
}
