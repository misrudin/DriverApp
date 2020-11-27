//
//  LoginViewModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 16/10/20.
//

import Foundation
import AesEverywhere
import Alamofire




struct LoginViewModel {
    
    var delegate: LoginViewModelDelegate?
    
    func signIn(codeDriver: String, password: String)-> Void{
        let userLogin = LoginData.init(codeDriver: codeDriver, password: password)
        
        let encoder = JSONEncoder()
        
        if let jsonData = try? encoder.encode(userLogin) {
            if let jsonString = String(data: jsonData, encoding: .utf8){
                let crypted = try! AES256.encrypt(input: jsonString, passphrase: Base.paswordEncKey)
                let dataToPost: [String:String] = [
                    "data" : crypted
                ]
                AF.request("\(Base.urlDriver)login",
                           method: .post,
                           parameters: dataToPost,
                           encoder: JSONParameterEncoder.default, headers: Base.headers).response(completionHandler: {(response) in
                            debugPrint(response)
                            switch response.result {
                            case .success:
                                if let data = response.data {
                                    if let userData =  self.parseJson(data: data){
                                        delegate?.didLoginSuccess(self, user: userData)
                                    }
                                }
                            case.failure(let error):
                                delegate?.didFailedLogin(error)
                            }
                            
                    })
            }
        }
    }

    
    func parseJson(data: Data) -> User?{
        do{
            let decodedData = try JSONDecoder().decode(UserDetail.self, from: data)
            let idDriver = decodedData.data.id
            let codeDriver = decodedData.data.codeDriver
            let status = decodedData.data.status
            let user = User(id: idDriver, codeDriver: codeDriver, status: status)
            return user
        }catch{
            delegate?.didFailedLogin(error)
            return nil
        }
    }
    
}



