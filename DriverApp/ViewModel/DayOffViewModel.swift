//
//  DayOffViewModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 06/11/20.
//

import Foundation
import Alamofire
import SwiftyJSON

struct DayOffViewModel {
    
    //MARK: - Get data day off
    func getDataDayOff(codeDriver: String, completion: @escaping (Result<DayOffModel,Error>)->Void){
        AF.request("\(Base.urlDriver)detail/days-off/\(codeDriver)",headers: Base.headers).responseData { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    if let safeData = decodeData(data: data) {
                        completion(.success(safeData))
                    }else{
                        completion(.failure(DataError.failedToFetch))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    //MARK: - RQUEST NEXT MONTH DAYOFF
    func setPlanDayOff(data: [String: Any], codeDriver: String, idGroup: Int, completion: @escaping (Result<Bool,Error>)-> Void){
        let date = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormater.string(from: date)
        
        let parameters:[String: Any] = [
            "code_driver" : codeDriver,
            "day_off_status": data,
            "date_add": dateString,
            "id_group": idGroup
        ]
        

        AF.request("\(Base.urlDriver)validate/days-off/next",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default, headers: Base.headers).response(completionHandler: {(response) in
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
                        
                    case let .failure(error):
                        completion(.failure(error))
                    }
            })
    }
    
    //MARK: - REQUEST CHANGE CURRENT DAYOFF
    func reqChangeDayoff(data: [String: Any], codeDriver: String, idGroup: Int, completion: @escaping (Result<Bool,Error>)-> Void){
        let date = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormater.string(from: date)
        
        let parameters:[String: Any] = [
            "code_driver" : codeDriver,
            "day_off_status": data,
            "date_add": dateString,
            "id_group": idGroup
        ]
        
        AF.request("\(Base.urlDriver)validate/days-off/now",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default, headers: Base.headers).response(completionHandler: {(response) in
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
                        
                    case let .failure(error):
                        completion(.failure(error))
                    }
            })
    }
    
    //MARK: - GET DATA WAITING APPROVAL DAYOF
    func getWaitingApproval(codeDriver: String, completion: @escaping (Result<WaitingDayOff, Error>)-> Void){
        let parameters:[String: Any] = [
            "code_driver" : codeDriver,
        ]
        
        AF.request("\(Base.urlDriver)validate/days-off/now/detail",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default, headers: Base.headers).response(completionHandler: {(response) in
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
                                if let data = response.data {
                                    if let safeData = decodePlanData(data: data) {
                                        completion(.success(safeData))
                                    }else{
                                        completion(.failure(DataError.failedToFetch))
                                    }
                                }
                            }
                        }
                        
                    case let .failure(error):
                        completion(.failure(error))
                    }
            })
    }
     
    
    //MARK: - GET DATA WAITING APPROVAL DAYOF NEXT MONTH
    func getWaitingApprovalNextMonth(codeDriver: String, completion: @escaping (Result<WaitingDayOff, Error>)-> Void){
        let parameters:[String: Any] = [
            "code_driver" : codeDriver,
        ]
        
        AF.request("\(Base.urlDriver)validate/days-off/next/detail",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default, headers: Base.headers).response(completionHandler: {(response) in
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
                                if let data = response.data {
                                    if let safeData = decodePlanData(data: data) {
                                        completion(.success(safeData))
                                    }else{
                                        completion(.failure(DataError.failedToFetch))
                                    }
                                }
                            }
                        }
                        
                    case let .failure(error):
                        completion(.failure(error))
                    }
            })
    }
    
    
    //MARK: - decode data dayoff
    private func decodeData(data: Data)-> DayOffModel? {
        do{
            let decodedData = try JSONDecoder().decode(DayOffModel.self, from: data)
            return decodedData
        }catch{
            print(error)
            return nil
        }
        
    }
    
    //MARK: - decode data plan
    private func decodePlanData(data: Data)-> WaitingDayOff? {
        do{
            let decodedData = try JSONDecoder().decode(WaitingDayOffParent.self, from: data)
            return decodedData.data
        }catch{
            print(error)
            return nil
        }
        
    }
}



