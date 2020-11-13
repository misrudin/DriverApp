//
//  InOutViewModel.swift
//  DriverApp
//
//  Created by Indo Office4 on 13/11/20.
//

import Foundation
import Alamofire
import CoreLocation

struct InOutViewModel {
    func cekStatusDriver(idDriver: Int, completion: @escaping (Result<StatusInOutDriver, Error>)-> Void){
        let dataToPost: CheckDriver = CheckDriver(id_driver: idDriver)
        
        AF.request("\(Base.url)livetracking/driver/dashboard/status/check",
                   method: .post,
                   parameters: dataToPost,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).response(completionHandler: {(response) in
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
    
    
    func checkinDriver(with idDriver: Int, lat: String, long: String, completion: @escaping (Result<Bool, Error>)-> Void){
        let dataToPost: CheckinData = CheckinData(id_driver: idDriver, lat: lat, long: long)
        
        AF.request("\(Base.url)livetracking/driver/dashboard/checkin",
                   method: .post,
                   parameters: dataToPost,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).response(completionHandler: {(response) in
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
                        completion(.failure(ErrorDriver.failedToPost))
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
                "Failed to get data from server.",
                comment: ""
            )
        case .notCheckinCheckout:
            return NSLocalizedString(
                "Driver not checkin/checkout yet",
                comment: ""
            )
        case .failedToPost:
            return NSLocalizedString(
                "Failed to post data",
                comment: ""
            )
        case .failedToDecode:
            return NSLocalizedString(
                "Failed to decode json data",
                comment: ""
            )
        }
    }
}
