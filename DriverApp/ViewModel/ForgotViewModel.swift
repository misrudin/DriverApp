//
//  ForgotViewModel.swift
//  DriverApp
//
//  Created by Indo Office4 on 13/11/20.
//

import Foundation
import Alamofire

struct ForgotViewModel {
    func forgotPassword(email: String, completion: @escaping (Result<Bool, Error>)-> Void){
        let dataToPost: ForgetPasswordData = ForgetPasswordData(email: email, url: Base.baseUrlResetPassword)
        
        AF.request("\(Base.urlDriver)forgot/password",
                   method: .post,
                   parameters: dataToPost,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).response(completionHandler: {(response) in
                    switch response.result {
                    case .success:
                        if let statusCode = response.response?.statusCode {
                            if statusCode != 200 {
                                completion(.failure(DataError.emailDoesNotExist))
                            }else {
                                completion(.success(true))
                            }
                        }
                        
                    case.failure(let error):
                        completion(.failure(error))
                    }
                    
            })
    }
    
    private enum DataError: Error {
        case emailDoesNotExist
    }
}
