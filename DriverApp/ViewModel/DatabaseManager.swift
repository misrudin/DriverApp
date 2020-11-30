//
//  DatabaseManager.swift
//  DriverApp
//
//  Created by Indo Office4 on 29/11/20.
//

import Foundation
import CoreLocation
import FirebaseDatabase

struct DatabaseManager {
    private let database = Database.database().reference()
    
    func updateData(idDriver: String, codeDriver: String, lat: CLLocationDegrees, lng: CLLocationDegrees, status: String,bearing: CLLocationDirection, completion: @escaping (Result<Bool, Error>)-> Void){
        
        let urlFirebase: String = "driver/\(codeDriver)"
        let dataToPost: [String: Any] = [
            "diver_id": idDriver,
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
            debugPrint(response)
            completion(.success(true))
        }
        
    }
    
    enum DatabaseError: Error {
        case failedToUpdateData
    }
}
