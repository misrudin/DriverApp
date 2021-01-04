//
//  ChatViewModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 24/10/20.
//

import Foundation
import FirebaseDatabase
import SwiftyJSON

struct ChatViewModel {
    private let database = Database.database().reference()
    
    let idAdmin = "17257"
    
    func getAllMsssages(codeDriver: String, completion: @escaping (Result<[[ChatMessage]],Error>)-> Void){
        let urlFirebase = "chatting/\(codeDriver)_\(idAdmin)/allChat"
        database.child(urlFirebase).observe(.value) { (snapshot) in
            
            guard let data = snapshot.value as? [String: [String: Any]] else{
                //                                completion(.failure(DatabaseError.failedToFetch))
                var tempData = [[ChatMessage]]()
                let boot = [
                    ChatMessage(text: nil, isIncoming: true, date: Date(), time: "", photo: nil)
                ]
                tempData.append(boot)
                completion(.success(tempData))
                return
            }
            
            var tempData = [[ChatMessage]]()
            let sortedKeyDate = data.keys.sorted()
            sortedKeyDate.forEach { (e) in
                let values = data[e] as! [String: [String: Any]]
                var newValues = [ChatMessage]()
                let sortedValues = values.keys.sorted()
                
                sortedValues.forEach({ (key) in
                    
                    let value = values[key]!
                    
                    guard let sender = value["sendBy"] else {return}
                    let isMe = "\(sender)" == codeDriver
                    
                    let newDic = ChatMessage(text: "\(value["chatContent"] ?? "")", isIncoming: isMe, date: Date.dateFromCustomString(customString: e), time: "\(value["chatTime"] ?? "")", photo: "\(value["file"] ?? "")")
                    
                    newValues.append(newDic)
                })
                tempData.append(newValues)
            }
            
            let boot = [
                ChatMessage(text: nil, isIncoming: true, date: Date(), time: "", photo: nil)
            ]
            tempData.append(boot)
            
            completion(.success(tempData))
        }
    }
    
    func getNewMessageValue(codeDriver: String, completion: @escaping (Int)->Void){
        let urlFirebase = "messages/\(idAdmin)/\(codeDriver)_\(idAdmin)"
        database.child(urlFirebase).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String: Any], let value = data["newMessage"] as? Int else{
                completion(0)
                return
            }
            completion(value)
        }
    }
    
    func sendMessage(codeDriver: String, chat: String, completion: @escaping (Bool)-> Void){
        let dateNow = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm"
        
        let timeString = timeFormat.string(from: dateNow)
        
        let dateStringNow = dateFormater.string(from: dateNow)
        
        let dateFormatString = DateFormatter()
        dateFormatString.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateString = dateFormatString.string(from: dateNow)
        
        let chatId = "\(codeDriver)_\(idAdmin)"
        let urlFirebase = "chatting/\(chatId)/allChat/\(dateStringNow)"
        let urlMessages = "messages/\(idAdmin)/\(chatId)"
        
        
        let chatdData:Message = Message(chatContent: chat,
                                        chatDate: dateString,
                                        sendBy: codeDriver,
                                        chatTime: timeString)
        let historyChat: HistoryMessage = HistoryMessage(lastContentChat: chat,
                                                         lastFileSend: "",
                                                         lastChatDate: dateString,
                                                         codeDriver: codeDriver,
                                                         token: "")
        
        let chatDataDict: [String: Any] = [
            "chatContent" : chatdData.chatContent,
            "chatDate" : chatdData.chatDate,
            "chatTime" : chatdData.chatTime,
            "sendBy" : Int(chatdData.sendBy)!,
        ]
        //push data
        database.child(urlFirebase).childByAutoId().setValue(chatDataDict) { (error, _) in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
        
        getNewMessageValue(codeDriver: codeDriver) { (val) in
            DispatchQueue.main.async {
                let historyChatDic: [String: Any] = [
                    "lastContentChat": historyChat.lastContentChat,
                    "lastFileSend": historyChat.lastFileSend,
                    "lastChatDate": historyChat.lastChatDate,
                    "codeDriver": historyChat.codeDriver,
                    "token": historyChat.token,
                    "newMessage": val + 1
                ]
                //buat history untuk cs
                database.child(urlMessages).setValue(historyChatDic) { (err, _) in
                    guard err == nil else {
                        return
                    }
                    
                }
            }
        }
    }
    
    
    func sendMessage(codeDriver: String, foto: String, chat: String, completion: @escaping (Bool)-> Void){
        let dateNow = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm"
        
        let timeString = timeFormat.string(from: dateNow)
        
        let dateStringNow = dateFormater.string(from: dateNow)
        
        let dateFormatString = DateFormatter()
        dateFormatString.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateString = dateFormatString.string(from: dateNow)
        
        let chatId = "\(codeDriver)_\(idAdmin)"
        let urlFirebase = "chatting/\(chatId)/allChat/\(dateStringNow)"
        let urlMessages = "messages/\(idAdmin)/\(chatId)"
        
        
        let historyChat: HistoryMessage = HistoryMessage(lastContentChat: "Foto",
                                                         lastFileSend: "Foto",
                                                         lastChatDate: dateString,
                                                         codeDriver: codeDriver,
                                                         token: "")
        
        let chatDataDict: [String: Any] = [
            "file" : "data:image/png;base64, \(foto)",
            "chatDate" : dateString,
            "chatTime" : timeString,
            "sendBy" : Int(codeDriver)!,
            "chatContent": chat
        ]
        //push data
        database.child(urlFirebase).childByAutoId().setValue(chatDataDict) { (error, _) in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
        
        getNewMessageValue(codeDriver: codeDriver) { (val) in
            DispatchQueue.main.async {
                let historyChatDic: [String: Any] = [
                    "lastContentChat": historyChat.lastContentChat,
                    "lastFileSend": historyChat.lastFileSend,
                    "lastChatDate": historyChat.lastChatDate,
                    "codeDriver": historyChat.codeDriver,
                    "token": historyChat.token,
                    "newMessage": val + 1
                ]
                //buat history untuk cs
                database.child(urlMessages).setValue(historyChatDic) { (err, _) in
                    guard err == nil else {
                        return
                    }
                    
                }
            }
        }
    }
    
    
    
    
    public enum DatabaseError: Error{
        case failedToFetch
    }
}


