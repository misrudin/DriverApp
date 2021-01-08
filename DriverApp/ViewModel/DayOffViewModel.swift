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
    func setPlanDayOff(data: [String: Any], codeDriver: String, completion: @escaping (Result<Bool,Error>)-> Void){
        let parameters:[String: Any] = [
            "code_driver" : codeDriver,
            "day_off_status": data
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
                                        completion(.failure(OrderError.failedToFetch(re.Message)))
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
    func reqChangeDayoff(data: [String: Any], codeDriver: String, completion: @escaping (Result<Bool,Error>)-> Void){
        let parameters:[String: Any] = [
            "code_driver" : codeDriver,
            "day_off_status": data
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
                                        completion(.failure(OrderError.failedToFetch(re.Message)))
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
    private func decodePlanData(data: Data)-> DayOfPlan? {
        do{
            let decodedData = try JSONDecoder().decode(DayOffPlanModel.self, from: data)
            return decodedData.data
        }catch{
            print(error)
            return nil
        }
        
    }
}



