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
    func getDataDayOff(codeDriver: String, completion: @escaping (Result<DayOfParent,Error>)->Void){
        AF.request("\(Base.urlDriver)detail/days-off/\(codeDriver)",headers: Base.headers).responseData { response in
//            debugPrint(response)
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
    
    
    //MARK: - GET PLAN NEXT MONTH
//    func getDataPlanDayOff(idDriver: String, completion: @escaping (Result<DayOfPlan,Error>)->Void){
//        AF.request("\(Base.url)livetracking/driver/plan/dayoff/\(idDriver)",headers: Base.headers).responseData { response in
//
//            switch response.result {
//            case .success:
//                if let data = response.data {
//                    if let safeData = decodePlanData(data: data) {
//                        completion(.success(safeData))
//                    }else{
//                        completion(.failure(DataError.failedToFetch))
//                    }
//                }
//            case let .failure(error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    
    //MARK: - set plan day off
    func setPlanDayOff(data: [String: Any], codeDriver: String, completion: @escaping (Result<Bool,Error>)-> Void){
        let parameters:[String: Any] = [
            "code_driver" : codeDriver,
            "day_off_status_plan": data
        ]
        
//        print(parameters)
        

        AF.request("\(Base.urlDriver)plan/days-off",
                   method: .patch,
                   parameters: parameters,
                   encoding: JSONEncoding.default, headers: Base.headers).response(completionHandler: {(response) in
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        completion(.success(true))
                    case let .failure(error):
                        completion(.failure(error))
                    }
            })
    }
    
     
    
    
    //MARK: - decode data dayoff
    private func decodeData(data: Data)-> DayOfParent? {
        do{
            let decodedData = try JSONDecoder().decode(DayOffModel.self, from: data)
            return decodedData.data
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



