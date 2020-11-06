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
}
