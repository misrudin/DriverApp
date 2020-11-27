//
//  NoteViewModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 22/10/20.
//

import Foundation

import Foundation
import Alamofire


struct NoteViewModel {
    //MARK: - GET DATA NOTE CHECKOUT DRIVER
    func getDataNoteCheckout(codeDriver: String, completion: @escaping (Result<NotesCheckout,Error>)-> Void){
        AF.request("\(Base.urlDriver)detail/note/checkout/\(codeDriver)/1/10",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    if let dataNotes = self.parseJson(data: data){
                        debugPrint(dataNotes)
                        completion(.success(dataNotes))
                    }else {
                        completion(.failure(DataError.failedToFetch))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
    //MARK: GET DATA NOTE PENDING DRIVER
    func getDataNotePending(codeDriver: String, completion: @escaping (Result<NotesPending,Error>)->Void){
        AF.request("\(Base.urlDriver)detail/note/pending/\(codeDriver)/1/10",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    if let pendingData = self.parseHistory(data: data){
                        completion(.success(pendingData))
                    }else {
                        completion(.failure(DataError.failedToFetch))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
    //MARK: - SEND PENDING NOTE
    func pendingNote(data: DataPending, completion: @escaping (Result<Bool,Error>)-> Void){
        AF.request("\(Base.urlDriver)note/pending",
                   method: .post,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            completion(.success(true))
                        }else{
                            completion(.failure(DataError.failedToSendingNote))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                   })
    }
    
    
    //MARK: - SEND CHECKOUT NOTE
    func checkoutNote(data: DataCheckout, completion: @escaping (Result<Bool,Error>)-> Void){
        AF.request("\(Base.urlDriver)note/checkout",
                   method: .post,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            completion(.success(true))
                        }else{
                            completion(.failure(DataError.failedToSendingNote))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                   })
    }
    
    
    
    //MARK: - TEMP DELETE NOTE
    func deleteNote(id: Int, completion: @escaping (Result<Bool,Error>)-> Void){
        let dataToPost:[String:Int] = ["id_note":id]
        
        AF.request("\(Base.urlDriver)note/delete",
                   method: .delete,
                   parameters: dataToPost,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).response(completionHandler: {(response) in
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            completion(.success(true))
                        } else {
                            completion(.failure(DataError.failedToDeleteNote))
                        }
                    case.failure(let error):
                        completion(.failure(error))
                    }
                    
                   })
    }
    
    
    //MARK: - EDIT PENDING NOTE
    func editNotePending(id: Int, note: String, completion: @escaping (Result<Bool,Error>)-> Void){
        let dataToPost = DataEditPending(id_note: id, note: note)
        AF.request("\(Base.urlDriver)note/pending",
                   method: .patch,
                   parameters: dataToPost,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).response(completionHandler: {(response) in
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            completion(.success(true))
                        }else {
                            completion(.failure(DataError.failedToSendingNote))
                        }
                    case.failure(let error):
                       print(error)
                        completion(.failure(error))
                    }

                   })
    }
    
    //MARK: - EDIT CHECKOUT NOTE
    func editNoteCheckout(id: Int, note: String, completion: @escaping (Result<Bool,Error>)-> Void){
        let dataToPost = DataEditCheckout(id_note_driver_chcekout: id, note: note)
        AF.request("\(Base.urlDriver)note/checkout",
                   method: .patch,
                   parameters: dataToPost,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).response(completionHandler: {(response) in
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            completion(.success(true))
                        }else {
                            completion(.failure(DataError.failedToSendingNote))
                        }
                    case.failure(let error):
                       print(error)
                        completion(.failure(error))
                    }

                   })
    }
    
    //MARK: - PARSE DATA
    // PARSE NOTE CHECKOUT
    func parseJson(data: Data) -> NotesCheckout?{
        do{
            let decodedData = try JSONDecoder().decode(NotesCheckout.self, from: data)
            return decodedData
        }catch{
            return nil
            
        }
    }
    
    //   PARSE NOTE PENDING
    func parseHistory(data: Data) -> NotesPending?{
        do{
            let decodedData = try JSONDecoder().decode(NotesPending.self, from: data)
            return decodedData
        }catch{
            return nil
        }
    }
    
    //MARK: - ENUM - ERROR
    enum DataError: Error{
        case failedToFetch
        case failedToSendingNote
        case failedToDeleteNote
    }
    
    
}
