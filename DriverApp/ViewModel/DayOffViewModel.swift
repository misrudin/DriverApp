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
    func getDataDayOff(idDriver: String, completion: @escaping (Result<DayOffStatus,Error>)->Void){
        AF.request("\(Base.url)livetracking/driver/detail/dayoff/\(idDriver)",headers: Base.headers).responseData { response in
            
            switch response.result {
            case .success:
                if let data = response.data {
                    if let safeData = decodeSData(data: data) {
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
    
    func setPlanDayOff(data: [String: Any]){
        
        
        let parameters:[String: Any] = [
            "id_driver" : 19,
            "day_off_status_plan": data
        ]
        
        print(parameters)
        

        AF.request("\(Base.url)livetracking/driver/plan/update/dayoff",
                   method: .patch,
                   parameters: parameters,
                   encoding: JSONEncoding.default, headers: Base.headers).response(completionHandler: {(response) in
                    debugPrint(response)
            })
    }
    
    
    private func encode( value: DayOffPost) -> Data {
         return withUnsafePointer(to:value) { p in
             Data(bytes: p, count: MemoryLayout.size(ofValue:value))
         }
     }
     
    
    
    private func decodeSData(data: Data)-> DayOffStatus? {
        do{
            let decodedData = try JSONDecoder().decode(DayOffModel.self, from: data)
            return decodedData.data.dayOfStatus
        }catch{
            print(error)
            return nil
        }
        
    }
    
    public enum DataError: Error{
            case failedToFetch
    }
    
    
    func decodeDataPlan(data: Data)-> DayOffStatus? {
        do{
            let decodedData = try JSONDecoder().decode(DayOfPlan.self, from: data)
            return decodedData.dayOfStatus
        }catch{
            print(error)
            return nil
        }
        
    }
}


extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
