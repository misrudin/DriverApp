//
//  LoginModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 16/10/20.
//

import Foundation

struct Root<T: Decodable>: Decodable {
    let data: [T]?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct LoginData: Codable {
    let code_driver: String
    let password: String
    
    init(codeDriver: String, password: String) {
        self.code_driver = codeDriver
        self.password = password
    }
}

struct User: Codable {
    let id: Int
    let codeDriver: String
    let status: String
    let id_group: Int?
    let bio: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id_driver"
        case codeDriver = "code_driver"
        case status = "working_status"
        case id_group = "id_group"
        case bio
    }
}


struct UserDetail: Decodable {
    let data: User
    
    enum CodingKeys: String, CodingKey {
        case  data = "data"
    }
}


//MARK - forget password
struct ForgetPasswordData: Codable {
    let email: String
    let url: String
}
