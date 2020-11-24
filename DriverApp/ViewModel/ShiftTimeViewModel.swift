//
//  ShiftTimeViewModel.swift
//  DriverApp
//
//  Created by Indo Office4 on 24/11/20.
//

import Foundation
import Alamofire

struct ShifttimeViewModle {
    //MARK: Get List shift time
    
    func getAllShiftTime(completion: @escaping (Result<[ShiftTime],Error>)-> Void){
//        AF.request("\(Base.urlOrder)list/\(codeDriver)",headers: Base.headers).response { response in
//            switch response.result {
//            case .success:
//                if response.response?.statusCode == 200 {
//                    if let data = response.data {
//                        if let orderData =  self.parseJson(data: data){
//                            completion(.success(orderData))
//                        }else {
//                            completion(.failure(DataError.failedToParseJson))
//                        }
//                    }
//                }else {
//                    completion(.failure(DataError.failedToFetch))
//                }
//            case let .failure(error):
//                completion(.failure(error))
//            }
//        }
    }
}
