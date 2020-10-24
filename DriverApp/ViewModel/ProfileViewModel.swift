//
//  ProfileViewModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 16/10/20.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ProfileViewModel {
    var delegate: ProfileViewModelDelegate?
    
    func getDetailUser(with codeDriver: String)->Void{
        AF.request("\(Base.url)livetracking/driver/dashboard/detail/\(codeDriver)",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    if let userData =  self.parseJson(data: data){
                        delegate?.didFetchUser(self, user: userData)
                    }
                }
            case let .failure(error):
                delegate?.didFailedToFetch(error)
            }
        }
    }
    
    //    Parese data
    func parseJson(data: Data) -> UserModel?{
        do{
            let decodedData = try JSONDecoder().decode(DataUser.self, from: data)
            return decodedData.data
        }catch{
            delegate?.didFailedToFetch(error)
            return nil
        }
    }
    
    func changePassword(data: PasswordModel, completion: @escaping (Result<ResultData,Error>)-> Void){
        AF.request("\(Base.url)livetracking/driver/edit/password",
                   method: .patch,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    
                    guard let data = response.data else {return}
                    
                    switch response.result {
                    case .success:
                        if let result = parseResult(data: data) {
                            completion(.success(result))
                        }else {
                            completion(.failure(DataError.failedToFetch))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                   })
    }
    
    func updateFoto(data: String, codeDriver: String, completion: @escaping (Result<FotoData,Error>)-> Void){
        let data = Foto(data: data, code_driver: codeDriver)
        
        AF.request("\(Base.url)livetracking/driver/edit/photo",
                   method: .patch,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    
                    debugPrint(response)
                    
        })
    }
    
    func updateProfile(data: DataProfile, completion: @escaping (Result<Bool,Error>)-> Void){
        AF.request("\(Base.url)livetracking/driver/apps/update",
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
    
    
    //    Parese data
    func parseResult(data: Data) -> ResultData?{
        do{
            let decodedData = try JSONDecoder().decode(ResultData.self, from: data)
            return decodedData
        }catch{
            return nil
        }
    }
    
    public enum DataError: Error{
        case failedToFetch
    }
    
}
