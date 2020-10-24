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
        AF.request("\(Base.url)order/schedule/detail/\(orderNo)",headers: Base.headers).responseJSON { response in
            debugPrint(response)
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
    
    func getDataOrder(codeDriver: String){
        AF.request("\(Base.url)order/schedule/driver/\(codeDriver)",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    if let orderData =  self.parseJson(data: data){
                        delegate?.didFetchOrder(self, order: orderData)
                    }
                }
            case let .failure(error):
                delegate?.didFailedGetOrder(error)
            }
        }
    }
    
    
    func getDataHistoryOrder(codeDriver: String, completion: @escaping (Result<HistoryData,Error>)->Void){
        AF.request("\(Base.url)order/history/\(codeDriver)",headers: Base.headers).response { response in
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
    
    
    func statusOrder(data: Delivery, status: String, completion: @escaping (Result<Bool,Error>)-> Void){
        AF.request("\(Base.url)order/schedule/update-status/\(status)",
                   method: .patch,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    switch response.result {
                    case .success:
                        completion(.success(true))
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
    
    public enum DataError: Error{
            case failedToFetch
    }
    
}
