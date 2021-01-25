//
//  OrderViewModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 18/10/20.
//

import Foundation
import Alamofire
import AesEverywhere
import LanguageManager_iOS

protocol OrderViewModelDelegate {
    //    func didFetchOrder(_ viewModel: OrderViewModel, order: OrderData)
    func didFailedGetOrder(_ error: Error)
}


struct OrderViewModel {
    var delegate: OrderViewModelDelegate?
    
    //    MARK: - GET DATA ORDER BY CODE DRIVER
    func getDataOrder(codeDriver: String, completion: @escaping (Result<[OrderListDate], Error>)-> Void){
        AF.request("\(Base.urlOrder)list/\(codeDriver)",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let data = response.data {
                        if let orderData =  parseDataOrder(data){
                            completion(.success(orderData))
                        }else {
                            completion(.failure(OrderError.failedToParseJson))
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
    
    
    //MARK: - GET DATA HISTORY ORDER
    func getDataHistoryOrder(codeDriver: String, completion: @escaping (Result<[History],Error>)->Void){
        AF.request("\(Base.urlOrder)today/history/\(codeDriver)",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let data = response.data {
                        if let orderData =  self.parseHistory(data: data){
                            completion(.success(orderData))
                        }else {
                            completion(.failure(OrderError.failedToParseJson))
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
                            if let data = response.data {
                                if let re = Helpers().decodeError(data: data){
                                    completion(.failure(OrderError.failedToUpdateData(re.Message_JP)))
                                }
                            }
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
                        completion(.failure(OrderError.failedToParseJson))
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
                            if let data = response.data {
                                if let re = Helpers().decodeError(data: data){
                                    completion(.failure(OrderError.failedToUpdateData(re.Message)))
                                }
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                   })
    }
    
    
    //MARK: - SCANED DATA
    //MARK: - CEK STATUS SCANDED ITEM
    func cekStatusItems(data: Scan, completion: @escaping (Result<[Scanned], Error>)-> Void) {
        AF.request("\(Base.urlOrder)scanned",
                   method: .post,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        if response.response?.statusCode  == 200 {
                            if let data = response.data {
                                if let scanData = parseScanData(data) {
                                    completion(.success(scanData))
                                }else {
                                    completion(.failure(OrderError.failedToParseJson))
                                }
                            }
                        }else {
                            if let data = response.data {
                                if let re = Helpers().decodeError(data: data){
                                    completion(.failure(OrderError.failedToFetch(re.Message_JP)))
                                }
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                   })
    }
    //MARK: - CHANGE STATUS SCANED DATA
    func changeStatusItems(data: Scan, completion: @escaping (Result<Bool,Error>)-> Void){
        AF.request("\(Base.urlOrder)scanned",
                   method: .patch,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        if response.response?.statusCode  == 200 {
                            completion(.success(true))
                        }else {
                            if let data = response.data {
                                if let re = Helpers().decodeError(data: data){
                                    completion(.failure(OrderError.failedToUpdateData(re.Message)))
                                }
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                   })
    }
    
    
    //    MARK: - CEK DRIVER FREELANCE REJECT ORDER
    func cekRejectOrder(driver: String, completion: @escaping (Result<ResponseReject,Error>)->Void){
        AF.request("\(Base.urlOrder)detail/reject/\(driver)",headers: Base.headers).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let data = response.data {
                        if let parsedData = parseReject(data) {
                            completion(.success(parsedData))
                        }else {
                            completion(.failure(OrderError.failedToParseJson))
                        }
                    }
                }else {
                    if let data = response.data {
                        if let re = Helpers().decodeError(data: data){
                            completion(.failure(OrderError.failedToFetch(re.Message)))
                        }
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
    //MARK: - REJECT ORDER FOR FLEELANCE
    func rejectOrder(data: DeleteHistory, completion: @escaping (Result<Bool,Error>)-> Void){
        AF.request("\(Base.urlOrder)update/reject",
                   method: .patch,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    switch response.result {
                    case .success:
                        if response.response?.statusCode  == 200 {
                            completion(.success(true))
                        }else {
                            if let data = response.data {
                                if let re = Helpers().decodeError(data: data){
                                    completion(.failure(OrderError.failedToUpdateData(re.Message)))
                                }
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                   })
    }
    
    //MARK: - Parse Data Order
    //    Parese data order
    private func parseDataOrder(_ data: Data) -> [OrderListDate]?{
        do{
            let decodedData = try JSONDecoder().decode(NewOrder.self, from: data)
            return decodedData.data
        }catch{
            return nil
        }
    }
    
    private func parseReject(_ data: Data) -> ResponseReject?{
        do{
            let decodedData = try JSONDecoder().decode(ResponseReject.self, from: data)
            return decodedData
        }catch{
            return nil
        }
    }
    
    //    Parese data history
    func parseHistory(data: Data) -> [History]?{
        do{
            let decodedData = try JSONDecoder().decode(HistoryData.self, from: data)
            return decodedData.data
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
    
    // Parse scaned data
    private func parseScanData(_ data: Data) -> [Scanned]? {
        do{
            let decodedData = try JSONDecoder().decode(ScanedData.self, from: data)
            return decodedData.data
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
    
}

enum OrderError: Error{
    case failedToFetch(_ message: String)
    case failedToParseJson
    case failedToUpdateData(_ message: String)
}

extension OrderError: LocalizedError {
    var errorDescription: String? {
        switch self {
        
        case .failedToFetch(let message):
            return NSLocalizedString(
                message,
                comment: ""
            )
        case .failedToParseJson:
            return NSLocalizedString(
                "Failed to parse data".localiz(),
                comment: ""
            )
        case .failedToUpdateData(let message):
            return NSLocalizedString(
                message,
                comment: ""
            )
        }
    }
}
