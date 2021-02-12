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
                                        guard let bio = decodeBio(data: userData.bio, codeDriver: userData.codeDriver) else {
                                            return
                                        }
                                        delegate?.didLoginSuccess(self, user: userData, bio: bio)
                                    }
                                }
                            case.failure(let error):
                                delegate?.didFailedLogin(error)
                            }
                            
                    })
            }
        }
    }
    
    private func decodeBio(data: String, codeDriver: String)-> Bio? {
            let decrypted = try! AES256.decrypt(input: data, passphrase: codeDriver)
            let data = Data(decrypted.utf8)
            let bioData = parseBio(data: data)
            return bioData
    }
    
    func parseBio(data: Data) -> Bio?{
        do{
            let decodedData = try JSONDecoder().decode(Bio.self, from: data)
            return decodedData
        }catch{
            return nil
        }
    }

    
    func parseJson(data: Data) -> User?{
        do{
            let decodedData = try JSONDecoder().decode(UserDetail.self, from: data)
            let idDriver = decodedData.data.id
            let codeDriver = decodedData.data.codeDriver
            let status = decodedData.data.status
            let idGroup = decodedData.data.id_group
            let bio = decodedData.data.bio
            let user = User(id: idDriver, codeDriver: codeDriver, status: status, id_group: idGroup, bio: bio)
            return user
        }catch{
            delegate?.didFailedLogin(error)
            return nil
        }
    }
    
}



