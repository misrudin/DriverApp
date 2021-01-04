//
//  NoteViewModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 22/10/20.
//

import Foundation

import Foundation
import Alamofire
import RxSwift
import RxCocoa

struct NoteViewModel {
    let items = PublishSubject<[Note]>()
    
    //MARK: - GET DATA NOTE CHECKOUT DRIVER
    func getDataNoteCheckout(codeDriver: String, completion: @escaping (Result<[Note],Error>)-> Void){
        AF.request("\(Base.urlDriver)detail/note/checkout/\(codeDriver)/1/10",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    if let dataNotes = self.parseJson(data: data){
                        completion(.success(dataNotes))
                    }else {
                        completion(.failure(NotesError.failedTodecode))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
    //MARK: GET DATA NOTE PENDING DRIVER
    func getDataNotePending(codeDriver: String, completion: @escaping (Result<[Note],Error>)->Void){
        AF.request("\(Base.urlDriver)today/note/pending/\(codeDriver)/50",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let data = response.data {
                        if let pendingData = self.parseJson(data: data){
                            completion(.success(pendingData))
                        }else {
                            completion(.failure(NotesError.failedTodecode))
                        }
                    }
                }else {
                    if let data = response.data {
                        if let er = Helpers().decodeError(data: data) {
                            completion(.failure(NotesError.failedToFetch(er.Message)))
                        }
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: GET DATA NOTE PENDING DRIVER
    func getNote(codeDriver: String){
        AF.request("\(Base.urlDriver)detail/note/pending/\(codeDriver)/1/10",headers: Base.headers).response { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let data = response.data {
                        if let pendingData = self.parseJson(data: data){
                            items.onNext(pendingData)
                            items.onCompleted()
                        }
                    }
                }else {
                    if let data = response.data {
                        if let er = Helpers().decodeError(data: data) {
                            print(er.Message)
                        }
                    }
                }
            case let .failure(error):
               print(error)
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
                            completion(.failure(NotesError.failedToSendingNote))
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
                            completion(.failure(NotesError.failedToSendingNote))
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
                            completion(.failure(NotesError.failedToDeleteNote))
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
                            completion(.failure(NotesError.failedToSendingNote))
                        }
                    case.failure(let error):
                       print(error)
                        completion(.failure(error))
                    }

                   })
    }
    
    //MARK: - EDIT CHECKOUT NOTE
    func editNoteCheckout(id: Int, note: String, completion: @escaping (Result<Bool,Error>)-> Void){
        let dataToPost = DataEditCheckout(id_note: id, note: note)
        AF.request("\(Base.urlDriver)note/checkout",
                   method: .patch,
                   parameters: dataToPost,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).response(completionHandler: {(response) in
                    switch response.result {
                    case .success:
                        if response.response?.statusCode == 200 {
                            completion(.success(true))
                        }else {
                            completion(.failure(NotesError.failedToSendingNote))
                        }
                    case.failure(let error):
                       print(error)
                        completion(.failure(error))
                    }

                   })
    }
    
    //MARK: - PARSE DATA
    // PARSE NOTE CHECKOUT
    private func parseJson(data: Data) -> [Note]?{
        do{
            let decodedData = try JSONDecoder().decode(Notes.self, from: data)
            print(decodedData)
            return decodedData.data
        }catch{
            print(error)
            return nil
            
        }
    }

    
}

//MARK: - ENUM - ERROR
enum NotesError: Error{
    case failedToFetch(_ message: String)
    case failedToSendingNote
    case failedToDeleteNote
    case failedTodecode
}

extension NotesError: LocalizedError {
    var errorDescription: String? {
        switch self {
        
        case .failedToFetch(let message):
            return NSLocalizedString(
                message,
                comment: ""
            )
        case .failedToSendingNote:
            return NSLocalizedString(
                "Failed to sending note",
                comment: ""
            )
        case .failedToDeleteNote:
            return NSLocalizedString(
                "Failed to delete note",
                comment: ""
            )
        case .failedTodecode:
            return NSLocalizedString(
                "Failed to parse data",
                comment: ""
            )
        }
    }
}
