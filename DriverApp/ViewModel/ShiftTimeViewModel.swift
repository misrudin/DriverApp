//
//  ShiftTimeViewModel.swift
//  DriverApp
//
//  Created by Indo Office4 on 24/11/20.
//

import Foundation
import Alamofire
import LanguageManager_iOS


struct ShiftTimeViewModel {
    
    //MARK: Get List shift time
    
    func getAllShiftTime(completion: @escaping (Result<[ShiftTime],Error>)-> Void){
        AF.request("\(Base.urlOrder)shift-time",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let data = response.data {
                        if let dataShift =  self.decodeData(data: data){
                            completion(.success(dataShift))
                        }else {
                            completion(.failure(ErrorShift.failedToDecode))
                        }
                    }
                }else {
                    completion(.failure(DataError.failedToFetch))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getCurrentShiftTime(completion: @escaping (Result<ShiftTime,Error>)-> Void){
        AF.request("\(Base.urlOrder)current/shift-time",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let data = response.data {
                        if let dataShift =  self.decodeShiftTime(data: data){
                            completion(.success(dataShift))
                        }else {
                            completion(.failure(ErrorShift.failedToDecode))
                        }
                    }
                }else {
                    if let data = response.data {
                        if let re = Helpers().decodeError(data: data){
                            completion(.failure(OrderError.failedToFetch(re.Message_JP)))
                        }
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
//    MARK: - Decode json data from api
    private func decodeData(data: Data)-> [ShiftTime]? {
        do{
            let decodedData = try JSONDecoder().decode(AllShiftTime.self, from: data)
            return decodedData.data
        }catch{
            print(error)
            return nil
        }
    }
    
    private func decodeShiftTime(data: Data)-> ShiftTime? {
        do{
            let decodedData = try JSONDecoder().decode(CurrentShiftTime.self, from: data)
            return decodedData.data
        }catch{
            print(error)
            return nil
        }
    }

    
}


enum ErrorShift: Error {
    case failedToFetch
    case failedToPost
    case failedToDecode
}

extension ErrorShift: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToFetch:
            return NSLocalizedString(
                "Failed to get data from server.".localiz(),
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
