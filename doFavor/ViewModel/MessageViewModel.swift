//
//  MessageViewModel.swift
//  doFavor
//
//  Created by Khing Thananut on 21/4/2565 BE.
//

import SwiftUI
import Firebase
import Alamofire
import FirebaseStorage
import FirebaseDatabase

//import FirebaseFirestoreSwift

struct MessageViewModel {
    
    public var messagesArray: [FirebaseMessage] = []
    private let db = Database.database().reference()
    private let storage = Storage.storage().reference()
    
    public func fetchMessageData(conversation_id: String, completion: @escaping(Result<FirebaseMessage, MessageError>) -> Void){

        db.child("conversation").child(conversation_id).observe(.value, with: { (snapshot) in
            guard let data = snapshot.value as? NSDictionary else {
                print("Error fetch message") //Not found create new conversation
                let error = MessageError.ConversationNotFound
                completion(.failure(error))
                return
            }
            
            var MessageData = FirebaseMessage()
            let petitioner = data.object(forKey: "petitioner") as! [String:String]
            
            var petUser = FirebaseUserModel()
            petUser.id = petitioner["id"]
            petUser.firstname = petitioner["firstname"]
            petUser.lastname = petitioner["lastname"]
            petUser.publicKey = petitioner["publicKey"]
            
            let applicant = data.object(forKey: "applicant") as! [String:String]

            
            var appUser = FirebaseUserModel()
            appUser.id = applicant["id"]
            appUser.firstname = applicant["firstname"]
            appUser.lastname = applicant["lastname"]
            appUser.publicKey = applicant["publicKey"]
            
            MessageData.petitioner = petUser
            MessageData.applicant = appUser
            

            guard let messageArr = data.object(forKey: "message") as? [[String: Any]] else {
                completion(.success(MessageData))
                return
            }
            
            var arr = [MessageModel]()
            for con in messageArr {
                let userId = AppUtils.getUsrId()
                var otherPublicKey = ""
                
                if petUser.id == userId {
                    otherPublicKey = appUser.publicKey ?? ""
                } else if appUser.id == userId {
                    otherPublicKey = petUser.publicKey ?? ""
                }
                
                AppUtils.E2EE.decryptMessage(for: con["content"] as! String, otherPublicKey: otherPublicKey, conversation_id: conversation_id) { result in
                    
                    switch result {
                    case .success(let decrypted):
                        let msg = MessageModel(content: decrypted,
                                               date: con["date"] as? String,
                                               type: con["type"] as? String,
                                               sender: con["sender"] as? String)
                        arr.append(msg)
                    case .failure(_):
                        print("Error to decrypted")
                        let msg = MessageModel(content: con["content"] as? String,
                                               date: con["date"] as? String,
                                               type: "Encrypted",
                                               sender: con["sender"] as? String)
                        arr.append(msg)
                    }
                }
                
            }
        
            MessageData.message = arr

            completion(.success(MessageData))
        })

    }
    
    public func sendMessage(conversation_id: String, message: String, by: String, otherPublicKey: String, type: String, completion: @escaping(Bool) -> Void) {
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .long
            formatter.locale = .current
            formatter.dateFormat = "MMM dd', 'yyyy' at 'HH:mm:ss O"
            return formatter
        }()
        
        AppUtils.E2EE.encryptMessage(for: message, otherPublicKey: otherPublicKey, conversation_id: conversation_id) { result in
            switch result {
            case .success(let encrypted):
                let newMessage: [String: Any] = [
                    "content": encrypted,
                    "type": type,
                    "date": dateFormatter.string(from: Date()),
                    "sender": by
                ]
                
                db.child("conversation").child("\(conversation_id)/message").observeSingleEvent(of: .value, with: { snapshot in
                    if var currentMessages = snapshot.value as? [[String: Any]] {
                        currentMessages.append(newMessage)
                        
                        db.child("conversation").child("\(conversation_id)/message").setValue(currentMessages, withCompletionBlock: { error, _ in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            completion(true)
                        })
                    }
                    else {
                        var msgArray = [[String:Any]]()
                        msgArray.append(newMessage)
                        
                        db.child("conversation").child("\(conversation_id)/message").setValue(msgArray, withCompletionBlock: { error, _ in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            completion(true)
                        })
                    }
                    
                    
                })
            case .failure(let error):
                print("Error to encrypted",error)
                completion(false)
            }
        }
        
        
    }
    
    public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping (Result<String, ServiceError>) -> Void) {
        let headers: HTTPHeaders = ["Authorization" : AppUtils.getUsrAuthToken()!,
                                    "Content-Type": "multipart/form-data"]
        
        let request = AF.upload(multipartFormData: {
            MultipartFormData in
            MultipartFormData.append(data, withName: "file", fileName: fileName, mimeType: "image/jpeg")
        }, to: Constants.BASE_URL+Constants.FILE_UPLOAD_CONVERSATION_IMAGE, method: .post, headers: headers)

        request.responseDecodable(of: ResponseUploadImage.self) { (response) in
            print("RESPONSE",response)
            switch response.result {
            case .success(_):
                guard let data = response.value else {return}
                
                if data.result == "OK" {
                    let imageurl:ImageUrlDataModel = data.data
                    completion(.success(imageurl.url?[0] ?? ""))
                }
                else if data.result == "nOK" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.message)))
                }
                else if data.result == "Not found" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.result)))
                }
                else {
                    completion(.failure(ServiceError.Non200StatusCodeError(doFavorAPIError(message: data.result, status: "500"))))
                }
            case .failure(let error):
                print(error)
                if let afError = error.asAFError {
                    switch afError {
                    case .sessionTaskFailed(let sessionError):
                        if let urlError = sessionError as? URLError, urlError.code == .notConnectedToInternet {
                            completion(.failure(ServiceError.NoNetworkError))
                        }
                        else {
                            completion(.failure(ServiceError.UnParsableError))
                        }
                    default :
                        completion(.failure(ServiceError.UnParsableError))
                    }
                }
                completion(.failure(ServiceError.UnParsableError))
            }
        }
    }
    
//    public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
//        storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: { (metadata, error) in
//            guard error == nil else {
//                // failed
//                print("failed to upload data to firebase for picture")
//                completion(.failure(StorageErrors.failedToUpload))
//                return
//            }
//
//            storage.child("message_images/\(fileName)").downloadURL(completion: { url, error in
//                guard let url = url else {
//                    print("Failed to get download url")
//                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
//                    return
//                }
//
//                let urlString = url.absoluteString
//                print("download url returned: \(urlString)")
//                completion(.success(urlString))
//            })
//        })
//    }
    
    public func createNewConversation(conversation_id: String, publicKey: String, by petitioner: FirebaseUserModel?, completion: @escaping(Bool) -> Void) {

        let petData: [String:Any] = [
            "id": petitioner?.id ?? "",
            "firstname": petitioner?.firstname ?? "",
            "lastname": petitioner?.lastname ?? "",
            "publicKey": publicKey
        ]
        
        let appData: [String:Any] = [
            "id": "",
            "firstname": "",
            "lastname": "",
            "publicKey": ""
        ]
        
        let data: [String: Any] = [
            "petitioner": petData,
            "applicant": appData
        ]
        

        
        db.child("conversation").child(conversation_id).setValue(data, withCompletionBlock: { error,_ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    public func updateApplicantInConversation(conversation_id: String, publicKey: String, by applicant: FirebaseUserModel?, completion: @escaping(Bool) -> Void) {
        
        let appData: [String:Any] = [
            "id": applicant?.id ?? "",
            "firstname": applicant?.firstname ?? "",
            "lastname": applicant?.lastname ?? "",
            "publicKey": publicKey
        ]
        
        db.child("conversation").child(conversation_id).child("applicant").setValue(appData) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
              print("Data could not be saved: \(error).")
              completion(false)
          } else {
              print("Data saved successfully!")
              completion(true)
          }
        }
    }
    
//    func fetchMessageData(conversation_id: String, completion: @escaping(Result<FirebaseMessage, MessageError>) -> Void){
//
//        db.child("conversation").child(conversation_id).observe(.value, with: { (snapshot) in
//            guard let data = snapshot.value as? NSDictionary else {
//                print("Error fetch message") //Not found create new conversation
//                let error = MessageError.ConversationNotFound
//                completion(.failure(error))
//                return
//            }
//
//            var MessageData = FirebaseMessage()
//            let petitioner = data.object(forKey: "petitioner") as! [String:String]
//
//            var petUser = FirebaseUserModel()
//            petUser.id = petitioner["id"]
//            petUser.firstname = petitioner["firstname"]
//            petUser.lastname = petitioner["lastname"]
//            petUser.publicKey = petitioner["publicKey"]
//
//            let applicant = data.object(forKey: "applicant") as! [String:String]
//
//
//            var appUser = FirebaseUserModel()
//            appUser.id = applicant["id"]
//            appUser.firstname = applicant["firstname"]
//            appUser.lastname = applicant["lastname"]
//            appUser.publicKey = applicant["publicKey"]
//
//            MessageData.petitioner = petUser
//            MessageData.applicant = appUser
//
//            guard let messageArr = data.object(forKey: "message") as? [[String: Any]] else {
//                let error = MessageError.MessageNotFound
//                completion(.failure(error))
//                return
//            }
//
//            var arr = [MessageModel]()
//            for con in messageArr {
//                let msg = MessageModel(content: con["content"] as? String,
//                                       date: con["date"] as? String,
//                                       type: con["type"] as? String,
//                                       sender: con["sender"] as? String)
//                arr.append(msg)
//            }
//
//            MessageData.message = arr
//
//            completion(.success(MessageData))
//        })
//
//    }
    
//    func sendMessage(conversation_id: String, message: String, by: String, completion: @escaping(Bool) -> Void) {
//
//        let dateFormatter: DateFormatter = {
//            let formatter = DateFormatter()
//            formatter.dateStyle = .medium
//            formatter.timeStyle = .long
//            formatter.locale = .current
//            formatter.dateFormat = "MMM dd', 'yyyy' at 'HH:mm:ss O"
//            return formatter
//        }()
//
//        let newMessage: [String: Any] = [
//            "content": message,
//            "type": "text",
//            "date": dateFormatter.string(from: Date()),
//            "sender": by
//        ]
//
//        db.child("conversation").child("\(conversation_id)/message").observeSingleEvent(of: .value, with: { snapshot in
//            if var currentMessages = snapshot.value as? [[String: Any]] {
//                currentMessages.append(newMessage)
//
//                db.child("conversation").child("\(conversation_id)/message").setValue(currentMessages, withCompletionBlock: { error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//                    completion(true)
//                })
//            }
//            else {
//                var msgArray = [[String:Any]]()
//                msgArray.append(newMessage)
//
//                db.child("conversation").child("\(conversation_id)/message").setValue(msgArray, withCompletionBlock: { error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//                    completion(true)
//                })
//            }
//
//
//        })
//    }
    
//    func createNewConversation(conversation_id: String, by userId: String, publicKey: String, petitioner: ResponseUserTSCT?, applicant: ResponseUserTSCT?, completion: @escaping(Bool) -> Void) {
//
//        var petData: [String:Any] = [
//            "id": petitioner?.id ?? "",
//            "firstname": petitioner?.firstname ?? "",
//            "lastname": petitioner?.lastname ?? "",
//            "publicKey": ""
//        ]
//
//        var appData: [String:Any] = [
//            "id": applicant?.id ?? "",
//            "firstname": applicant?.firstname ?? "",
//            "lastname": applicant?.lastname ?? "",
//            "publicKey": ""
//        ]
//
//        if userId == petitioner?.id ?? "" {
//            petData["publicKey"] = publicKey
//        }
//        else if userId == applicant?.id ?? "" {
//            appData["publicKey"] = publicKey
//        }
//
//        let data: [String: Any] = [
//            "petitioner": petData,
//            "applicant": appData
//        ]
//
//
//
//        db.child("conversation").child(conversation_id).setValue(data, withCompletionBlock: { error,_ in
//            guard error == nil else {
//                completion(false)
//                return
//            }
//            completion(true)
//        })
//    }

}
