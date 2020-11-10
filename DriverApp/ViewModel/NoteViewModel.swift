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
    
    func getDataNoteCheckout(codeDriver: String, completion: @escaping (Result<NotesCheckout,Error>)-> Void){
        AF.request("\(Base.url)note/driver/checkout/\(codeDriver)/1/10",headers: Base.headers).response { response in
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
    
    
    func getDataNotePending(codeDriver: String, completion: @escaping (Result<NotesPending,Error>)->Void){
        AF.request("\(Base.url)note/driver/pending/\(codeDriver)/1/10",headers: Base.headers).response { response in
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
    
    func pendingNote(data: DataPending, completion: @escaping (Result<Bool,Error>)-> Void){
        AF.request("\(Base.url)note/pending",
                   method: .post,
                   parameters: data,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).responseJSON(completionHandler: {(response) in
                    switch response.result {
                    case .success:
                        completion(.success(true))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                   })
    }
    
    
    
    //MARK - delete pending note
    func deletePendingNote(id: Int, completion: @escaping (Result<Bool,Error>)-> Void){
        let dataToPost:[String:Int] = ["id_note":id]

        AF.request("\(Base.url)note/driver/pending",
                   method: .patch,
                   parameters: dataToPost,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).response(completionHandler: {(response) in
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        completion(.success(true))
                    case.failure(let error):
                       print(error)
                        completion(.failure(error))
                    }

                   })
    }
    
    //    MARK - delete pending note
    func deleteCheckoutNote(id: Int, completion: @escaping (Result<Bool,Error>)-> Void){
        let dataToPost:[String:Int] = ["id_note_driver_chcekout":id]

        AF.request("\(Base.url)note/driver/checkout",
                   method: .patch,
                   parameters: dataToPost,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).response(completionHandler: {(response) in
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        completion(.success(true))
                    case.failure(let error):
                       print(error)
                        completion(.failure(error))
                    }

                   })
    }
    
    
    //MARK - Edit Note Pending
    func editNotePending(id: Int, note: String, completion: @escaping (Result<Bool,Error>)-> Void){
        let dataToPost = DataEditPending(id_note: id, note: note)
        AF.request("\(Base.url)note/pending",
                   method: .patch,
                   parameters: dataToPost,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).response(completionHandler: {(response) in
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        completion(.success(true))
                    case.failure(let error):
                       print(error)
                        completion(.failure(error))
                    }

                   })
    }
    
    //MARK - Edit Note Checkout
    func editNoteCheckout(id: Int, note: String, completion: @escaping (Result<Bool,Error>)-> Void){
        let dataToPost = DataEditCheckout(id_note_driver_chcekout: id, note: note)
        AF.request("\(Base.url)note/checkout",
                   method: .patch,
                   parameters: dataToPost,
                   encoder: JSONParameterEncoder.default, headers: Base.headers).response(completionHandler: {(response) in
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        completion(.success(true))
                    case.failure(let error):
                       print(error)
                        completion(.failure(error))
                    }

                   })
    }
    
    //    Parese data order
    func parseJson(data: Data) -> NotesCheckout?{
        do{
            let decodedData = try JSONDecoder().decode(NotesCheckout.self, from: data)
            return decodedData
        }catch{
            return nil
            
        }
    }
    
    //    Parese data history
    func parseHistory(data: Data) -> NotesPending?{
        do{
            let decodedData = try JSONDecoder().decode(NotesPending.self, from: data)
            return decodedData
        }catch{
            return nil
        }
    }
    
    
    public enum DataError: Error{
            case failedToFetch
    }
    
    
}
