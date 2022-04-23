//
//  MessageViewModel.swift
//  doFavor
//
//  Created by Khing Thananut on 21/4/2565 BE.
//

import SwiftUI
import Firebase
import Alamofire
import FirebaseDatabase
//import FirebaseFirestoreSwift

struct MessageViewModel {
    
    public var messagesArray: [FirebaseMessage] = []
    let db = Database.database().reference()
    
    func fetchMessageData(conversation_id: String, completion: @escaping(Result<FirebaseMessage, MessageError>) -> Void){

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
                let error = MessageError.MessageNotFound
                completion(.failure(error))
                return
            }
            
            var arr = [MessageModel]()
            for con in messageArr {
                let msg = MessageModel(content: con["content"] as! String,
                                       date: con["date"] as! String,
                                       type: con["type"] as! String,
                                       sender: con["sender"] as! String)
                arr.append(msg)
            }
        
            MessageData.message = arr

            completion(.success(MessageData))
        })

    }
    
    func sendMessage(conversation_id: String, message: String, by: String, completion: @escaping(Bool) -> Void) {
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .long
            formatter.locale = .current
            formatter.dateFormat = "MMM dd', 'yyyy' at 'HH:mm:ss O"
            return formatter
        }()
        
        let newMessage: [String: Any] = [
            "content": message,
            "type": "text",
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
    }
    
    func createNewConversation(conversation_id: String, by userId: String, publicKey: String, petitioner: ResponseUserTSCT?, applicant: ResponseUserTSCT?, completion: @escaping(Bool) -> Void) {

        var petData: [String:Any] = [
            "id": petitioner?.id ?? "",
            "firstname": petitioner?.firstname ?? "",
            "lastname": petitioner?.lastname ?? "",
            "publicKey": ""
        ]
        
        var appData: [String:Any] = [
            "id": applicant?.id ?? "",
            "firstname": applicant?.firstname ?? "",
            "lastname": applicant?.lastname ?? "",
            "publicKey": ""
        ]
        
        if userId == petitioner?.id ?? "" {
            petData["publicKey"] = publicKey
        }
        else if userId == applicant?.id ?? "" {
            appData["publicKey"] = publicKey
        }
        
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

}
