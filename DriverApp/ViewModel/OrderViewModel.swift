//
//  OrderViewModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 18/10/20.
//

import Foundation
import Alamofire

protocol OrderViewModelDelegate {
    func didFetchOrder(_ viewModel: OrderViewModel, order: OrderData)
    func didFailedGetOrder(_ error: Error)
}


struct OrderViewModel {
    var delegate: OrderViewModelDelegate?
    
    func getDetailOrder(orderNo: String, completion: @escaping (Result<Order,Error>)->Void){
        AF.request("\(Base.url)orders/schedule/detail/\(orderNo)",headers: Base.headers).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    if let orderData =  self.parseDetail(data: data){
                        completion(.success(orderData))
                    }else {
                        completion(.failure(DataError.failedToFetch))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
//    MARK: - get data order
    func getDataOrder(codeDriver: String, completion: @escaping (Result<OrderData, Error>)-> Void){
        AF.request("\(Base.urlOrder)list/\(codeDriver)",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let data = response.data {
                        if let orderData =  self.parseJson(data: data){
                            completion(.success(orderData))
                        }else {
                            completion(.failure(DataError.failedToParseJson))
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
    
    
    func getDataHistoryOrder(codeDriver: String, completion: @escaping (Result<HistoryData,Error>)->Void){
        AF.request("\(Base.urlOrder)history/\(codeDriver)",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    if let orderData =  self.parseHistory(data: data){
                        completion(.success(orderData))
                    }else {
                        completion(.failure(DataError.failedToFetch))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
    //MARK: - Status order
    func statusOrder(data: Delivery, completion: @escaping (Result<Bool,Error>)-> Void){
        AF.request("\(Base.urlOrder)update/status",
                   method: .patch,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            completion(.success(true))
                        }else {
                            completion(.failure(DataError.failedToUpdateData))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                   })
    }
    
    //MARK: - Temp Delete History order
    func deleteOrder(data: DeleteHistory, completion: @escaping (Result<Bool,Error>)-> Void){
        AF.request("\(Base.urlOrder)update/history",
                   method: .patch,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    switch response.result {
                    case .success:
                        if response.response?.statusCode  == 200 {
                            completion(.success(true))
                        }else {
                            completion(.failure(DataError.failedToUpdateData))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                   })
    }
    
    //    Parese data order
    func parseJson(data: Data) -> OrderData?{
        do{
            let decodedData = try JSONDecoder().decode(OrderData.self, from: data)
            return decodedData
        }catch{
            delegate?.didFailedGetOrder(error)
            return nil
        }
    }
    
    //    Parese data history
    func parseHistory(data: Data) -> HistoryData?{
        do{
            let decodedData = try JSONDecoder().decode(HistoryData.self, from: data)
            return decodedData
        }catch{
            return nil
        }
    }
    
    //    Parese data detail
    func parseDetail(data: Data) -> Order?{
        do{
            let decodedData = try JSONDecoder().decode(OrderDetail.self, from: data)
            return decodedData.data
        }catch{
            print(error)
            return nil
        }
    }
    
    enum DataError: Error{
        case failedToFetch
        case failedToParseJson
        case failedToUpdateData
    }
    
}
