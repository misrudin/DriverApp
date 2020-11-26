//
//  OrderViewModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 18/10/20.
//

import Foundation
import Alamofire
import AesEverywhere

protocol OrderViewModelDelegate {
    func didFetchOrder(_ viewModel: OrderViewModel, order: OrderData)
    func didFailedGetOrder(_ error: Error)
}


struct OrderViewModel {
    var delegate: OrderViewModelDelegate?
    
//    MARK: - GET DATA ORDER BY CODE DRIVER
    func getDataOrder(codeDriver: String, completion: @escaping (Result<[NewOrderData], Error>)-> Void){
        AF.request("\(Base.urlOrder)list/\(codeDriver)",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let data = response.data {
                        if let orderData =  parseDataOrder(data){
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
    
    
    //MARK: - GET DATA HISTORY ORDER
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
    
    
    //MARK: - CHANGE STATUS ORDER
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
     
    
//    MARK: - GET DETAIL ORDER
    func getDetailOrder(orderNo: String, completion: @escaping (Result<NewOrderData,Error>)->Void){
        AF.request("\(Base.urlOrder)driver/detail/\(orderNo)",headers: Base.headers).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    if let detail =  self.parseDetail(data: data){
                        completion(.success(detail))
                    }else {
                        completion(.failure(DataError.failedToFetch))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
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
    
    //MARK: - Parse Data Order
    //    Parese data order
    private func parseDataOrder(_ data: Data) -> [NewOrderData]?{
        do{
            let decodedData = try JSONDecoder().decode(NewOrder.self, from: data)
            return decodedData.data
        }catch{
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
    func parseDetail(data: Data) -> NewOrderData?{
        do{
            let decodedData = try JSONDecoder().decode(OrderDetail.self, from: data)
            return decodedData.data
        }catch{
            print(error)
            return nil
        }
    }
    
    // Parse User info
    private func parseUserInfo(_ data: Data) -> NewUserInfo? {
        do{
            let decodedData = try JSONDecoder().decode(NewUserInfo.self, from: data)
            return decodedData
        }catch{
            print(error)
            return nil
        }
    }
    
    // Parse User info
    private func parseOrderDetail(_ data: Data) -> NewOrderDetail? {
        do{
            let decodedData = try JSONDecoder().decode(NewOrderDetail.self, from: data)
            return decodedData
        }catch{
            print(error)
            return nil
        }
    }
    
    
    //MARK: - Decrypt aes for order
    /// User info
    func decryptUserInfo(data: String, OrderNo: String)-> NewUserInfo? {
        let decrypted = try! AES256.decrypt(input: data, passphrase: OrderNo)
        let data = Data(decrypted.utf8)
        let userInfo = parseUserInfo(data)
        return userInfo
    }
    
    /// Order Detail
    func decryptOrderDetail(data: String, OrderNo: String)-> NewOrderDetail? {
        let decrypted = try! AES256.decrypt(input: data, passphrase: OrderNo)
        let data = Data(decrypted.utf8)
        let order = parseOrderDetail(data)
        return order
    }
    
    enum DataError: Error{
        case failedToFetch
        case failedToParseJson
        case failedToUpdateData
    }
    
}
