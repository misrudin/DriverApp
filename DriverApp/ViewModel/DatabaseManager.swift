//
//  DatabaseManager.swift
//  DriverApp
//
//  Created by Indo Office4 on 29/11/20.
//

import Foundation
import CoreLocation
import FirebaseDatabase
//import UIKit

struct DatabaseManager {
    private let database = Database.database().reference()
    let idAdmin = "17257"
    
    func updateData(idDriver: String, codeDriver: String, lat: CLLocationDegrees, lng: CLLocationDegrees, status: String,bearing: CLLocationDirection, completion: @escaping (Result<Bool, Error>)-> Void){
        
        let urlFirebase: String = "driver/\(codeDriver)"
        let dataToPost: [String: Any] = [
            "driver_id": idDriver,
            "id": codeDriver,
            "latitude": lat,
            "longitude": lng,
            "status_driver": status,
            "heading": bearing
        ]
        
        database.child(urlFirebase).updateChildValues(dataToPost) { (err, response) in
            if err != nil {
                completion(.failure(DatabaseError.failedToUpdateData))
                return
            }
            debugPrint(response)
            completion(.success(true))
        }
        
    }
    
    func updateStatus(codeDriver: String, status: String, completion: @escaping (Result<Bool, Error>)->Void){
        let urlFirebase: String = "driver/\(codeDriver)"
        let dataToPost: [String: Any] = [
            "status_driver": status
        ]
        
        database.child(urlFirebase).updateChildValues(dataToPost) { (err, response) in
            if err != nil {
                completion(.failure(DatabaseError.failedToUpdateData))
                return
            }
            debugPrint(response)
            completion(.success(true))
        }
        
    }
    
    func updateToken(codeDriver: String, token: String, completion: @escaping (Result<Bool, Error>)->Void){
        let urlFirebase: String = "driver/\(codeDriver)"
        let dataToPost: [String: Any] = [
            "token": token
        ]
        
        database.child(urlFirebase).updateChildValues(dataToPost) { (err, response) in
            if err != nil {
                completion(.failure(DatabaseError.failedToUpdateData))
                return
            }
            debugPrint(response)
            completion(.success(true))
        }
        
    }
    
    func logerIos(codeDriver: String, token: String, completion: @escaping (Result<Bool, Error>)->Void){
        let urlFirebase: String = "driver/\(codeDriver)"
        let dataToPost: [String: Any] = [
            "loger": token
        ]
        
        database.child(urlFirebase).updateChildValues(dataToPost) { (err, response) in
            if err != nil {
                completion(.failure(DatabaseError.failedToUpdateData))
                return
            }
            debugPrint(response)
            completion(.success(true))
        }
        
    }
    
    func updateHeading(codeDriver: String, bearing: CLLocationDirection, completion: @escaping (Result<Bool, Error>)->Void){
        let urlFirebase: String = "driver/\(codeDriver)"
        let dataToPost: [String: Any] = [
            "heading": bearing
        ]
        
        database.child(urlFirebase).updateChildValues(dataToPost) { (err, response) in
            if err != nil {
                completion(.failure(DatabaseError.failedToUpdateData))
                return
            }
            completion(.success(true))
        }
        
    }
    
    func setCurrentOrder(orderNo: String, status: String, codeDriver: String, completion: @escaping (Result<Bool, Error>)-> Void){
        let date = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        
        let dateNow: String = dateFormater.string(from: date)
        let urlFirebase = "monitoring/\(dateNow)/\(codeDriver)"

        let dataToPost: [String: Any] = [
            "current_order": orderNo,
            "order_status" : status
        ]
        
        database.child(urlFirebase).updateChildValues(dataToPost) { (err, res) in
            if err != nil {
                completion(.failure(DatabaseError.failedToUpdateData))
                return
            }
            completion(.success(true))
        }
        
    }
    
    func removeCurrentOrder(orderNo: String, codeDriver: String, completion: @escaping (Result<Bool, Error>)-> Void){
        let date = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        
        let dateNow: String = dateFormater.string(from: date)
        let urlFirebase = "monitoring/\(dateNow)/\(codeDriver)"

        database.child(urlFirebase).child("current_order").removeValue()
        database.child(urlFirebase).child("order_status").removeValue()
        
    }
    
    enum DatabaseError: Error {
        case failedToUpdateData
        case failedToFetch
    }
}
