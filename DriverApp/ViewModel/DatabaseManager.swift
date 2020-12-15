//
//  DatabaseManager.swift
//  DriverApp
//
//  Created by Indo Office4 on 29/11/20.
//

import Foundation
import CoreLocation
import FirebaseDatabase
import MessageKit
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
    
//    public func getAllChat(codeDriver: String, completion: @escaping (Result<[Pesan],Error>)-> Void){
//        let urlFirebase = "chatting/\(codeDriver)_\(idAdmin)/allChat"
//        database.child(urlFirebase).observe(.value) { (snapshot) in
//
//            guard let data = snapshot.value as? [String: [String: Any]] else{
//                            completion(.failure(DatabaseError.failedToFetch))
//                            return
//                        }
//
//            var tempData = [Pesan]()
//            let sortedKeyDate = data.keys.sorted()
//            sortedKeyDate.forEach { (e) in
//                let values = data[e] as! [String: [String: Any]]
//                var newValues = [Pesan]()
//                let sortedValues = values.keys.sorted()
//
//                sortedValues.forEach({ (key) in
//                    let value = values[key]!
//
//                    guard let senderId = value["sendBy"] as? Int,
//                          let content = value["chatContent"] as? String,
//                          let dateString = value["chatDate"] as? String
//                        else {
//                        print("ahoy")
//                        return}
//
//                    let date = Date.dateFromCustomString(customString: dateString)
//
//                    var kind: MessageKind?
//
//                    var type = "1"
//                    if value["file"] as? String != nil {
//                        type = "2"
//                    }else{
//                        type = "1"
//                    }
//
//                    if type == "2" {
//                        guard let photo = value["file"] as? String else {
//                            return
//                        }
//                        let photoBase64 = photo.replacingOccurrences(of: "data:image/png;base64,", with: " ")
//                        let imageData: Data = Data(base64Encoded: photoBase64.trimmingCharacters(in: .whitespacesAndNewlines))!
//                        let media = Media(url: nil,
//                                          image: UIImage(data: imageData),
//                                          placeholderImage: UIImage(named: "photoChat")!,
//                                          size: CGSize(width: 300, height: 300))
//                        kind = .photo(media)
//                    }else {
//                        kind = .text(content)
//                    }
//
//                    guard let finalKind = kind else {
//                        return
//                    }
//
//                    let messageId = "\(key)"
//
//                    let idSenderString = String(senderId)
//
//                    let sender: Sender = Sender(photoUrl: "", senderId: idSenderString, displayName: "Me")
//                    let newDic = Pesan(sender: sender, messageId: messageId, sentDate: date, kind: finalKind)
//
//                    newValues.append(newDic)
//                })
//                tempData.append(contentsOf: newValues)
//            }
//
////            let sender = Sender(photoUrl: "", senderId: codeDriver, displayName: "")
////            let new = Pesan(sender: sender, messageId: "xx0", sentDate: Date(), kind: .text("saya manusia biasa pa"))
////            tempData.append(new)
////
////            print(tempData)
//
//            completion(.success(tempData))
//        }
//    }
    
    
    enum DatabaseError: Error {
        case failedToUpdateData
        case failedToFetch
    }
}
