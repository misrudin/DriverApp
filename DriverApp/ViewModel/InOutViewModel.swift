//
//  InOutViewModel.swift
//  DriverApp
//
//  Created by Indo Office4 on 13/11/20.
//

import Foundation
import Alamofire
import CoreLocation
import LanguageManager_iOS

struct InOutViewModel {
    func cekStatusDriver(codeDriver: String, completion: @escaping (Result<StatusInOutDriver, Error>)-> Void){
        
        AF.request("\(Base.urlDriver)check/status/\(codeDriver)",
                   method: .get, headers: Base.headers).response(completionHandler: {(response) in
                    switch response.result {
                    case .success:
                        if let statusCode = response.response?.statusCode {
                            if statusCode != 200 {
                                completion(.failure(ErrorDriver.notCheckinCheckout))
                            }else {
                                if let data = response.data {
                                    debugPrint(data)
                                    if let safeData = decodeDataStatusDriver(data: data) {
                                        completion(.success(safeData))
                                    }else{
                                        completion(.failure(ErrorDriver.failedToDecode))
                                    }
                                }
                            }
                        }
                        
                    case.failure(let error):
                        print(error)
                        completion(.failure(ErrorDriver.failedToFetch))
                    }
                    
            })
    }
    
    private func decodeDataStatusDriver(data: Data)-> StatusInOutDriver? {
        do{
            let decodedData = try JSONDecoder().decode(DataParentStatus.self, from: data)
            return decodedData.data
        }catch{
            print(error)
            return nil
        }
    }
    
    
    func checkinDriver(with codeDriver: String, lat: String, long: String, completion: @escaping (Result<Bool, Error>)-> Void){
        let dataToPost: CheckinData = CheckinData(code_driver: codeDriver, lat: lat, long: long)
        
        AF.request("\(Base.urlDriver)check/in-out",
                   method: .post,
                   parameters: dataToPost,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).response(completionHandler: {(response) in
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        if let statusCode = response.response?.statusCode {
                            if statusCode != 200 {
                                completion(.failure(ErrorDriver.failedToPost))
                            }else {
                                completion(.success(true))
                                debugPrint(response)
                            }
                        }
                        
                    case.failure(let error):
                        print(error)
                        completion(.failure(ErrorDriver.failedToFetch))
                    }
                    
            })
    }
    
    
    //MARK: - Checkout
    func checkoutDriver(data: CheckDriver, completion: @escaping (Result<Bool, Error>)-> Void){
        AF.request("\(Base.urlDriver)check/in-out",
                   method: .patch,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            completion(.success(true))
                        }else {
                            completion(.failure(ErrorDriver.failedToPost))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
        })
    }
    
    //MARK: - Rest time
    
    func restTimeDriver(data: CheckDriver, completion: @escaping (Result<Bool, Error>)-> Void){
        AF.request("\(Base.urlDriver)rest-time",
                   method: .post,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            completion(.success(true))
                        }else {
                            completion(.failure(ErrorDriver.failedToPost))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
        })
    }
    
    //MARK: - Work Time
    
    func workTimeDriver(data: CheckDriver, completion: @escaping (Result<Bool, Error>)-> Void){
        AF.request("\(Base.urlDriver)rest-time",
                   method: .patch,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            completion(.success(true))
                        }else {
                            completion(.failure(ErrorDriver.failedToPost))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
        })
    }
    
    func updateLastPosition(data: CheckinData, completion: @escaping (Result<Bool, Error>)-> Void){
        AF.request("\(Base.urlDriver)check/last-position",
                   method: .patch,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            completion(.success(true))
                        }else {
                            completion(.failure(ErrorDriver.failedToPost))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
        })
    }

}


enum ErrorDriver: Error {
    case failedToFetch
    case notCheckinCheckout
    case failedToPost
    case failedToDecode
}

extension ErrorDriver: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToFetch:
            return NSLocalizedString(
                "Failed to get data from server.".localiz(),
                comment: ""
            )
        case .notCheckinCheckout:
            return NSLocalizedString(
                "Driver not checkin/checkout yet".localiz(),
                comment: ""
            )
        case .failedToPost:
            return NSLocalizedString(
                "Failed to post data".localiz(),
                comment: ""
            )
        case .failedToDecode:
            return NSLocalizedString(
                "Failed to decode json data".localiz(),
                comment: ""
            )
        }
    }
}
