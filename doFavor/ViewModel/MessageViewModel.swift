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
//    public var  testmock = [mocking]()
    
    
//    func fetchMessageData(conversation_id: String){
//        let ref = Database.database().reference().child("/624f69d13f8a07d7755851a6_conversation")
//
//
//        ref.observe(.value, with: { (snapshot) in
//            guard let data = snapshot.value as? NSDictionary else {
//                print("Error fetch message")
//                return
//            }
//            //            let petitionerID = data["petitioner"] as? String ?? ""
//            //            let applicantID = data["applicant"] as? String ?? ""
//
//            //            let eiei = JSONDecoder().decode(mocking, from: data)
//            //            print("MOCK",eiei)
//
//            //            print("dataaaaa",petitionerID)
//            //            print("DATA MODEL",data.value(forKey: "message"))
//            let testmock = mocking(app: data["app"] as? String ?? "",
//                                   pet: data["pet"] as? String ?? "")
//
//        })
//
//    }
    
    func fetchMessageData(conversation_id: String, completion: @escaping(Result<FirebaseMessage, Error>) -> Void){

        Database.database().reference().child(conversation_id).observe(.value, with: { (snapshot) in
            guard let data = snapshot.value as? NSDictionary else {
                print("Error fetch message")
                return
            }
            var MessageData = FirebaseMessage(
                petitioner: data["petitioner"] as? String ?? "",
                applicant: data["applicant"] as? String ?? "",
                message: [MessageModel(content: "", date: Date(), type: "", sender: "")])
            
//            print("TESTTTTTT", data.value(forKey: "message"))
            
            let eiei = data.object(forKey: "message") as! [[String: Any]]

            for con in eiei{
                MessageData.message.append(MessageModel(content: con["content"] as! String,
                                                        date: Date(),
                                                        type: con["type"] as! String,
                                                        sender: con["sender"] as! String))
            }

            completion(.success(MessageData))
            print("REAL",MessageData)

        })

    }

    
    func fetchMessageData2(conversation_id: String, completion: @escaping(Result<mocking, Error>) -> Void){

        Database.database().reference().child(conversation_id).observe(.value, with: { (snapshot) in
            guard let data = snapshot.value as? NSDictionary else {
                print("Error fetch message")
                return
            }
            
            let testmock = mocking(app: data["app"] as? String ?? "",
                               pet: data["pet"] as? String ?? "")

            completion(.success(testmock))

        })

    }


//    func fetchTest2(){
//        let ref = Database.database().reference().child("/mocking")
//
//        ref.observe(.value) { snapshot in
//            print("snap",snapshot)
//            print("is that",snapshot.value!)
//
//            let decoder = JSONDecoder()
//            if let decoded = try? decoder.decode(mocking.self, from: snapshot.value! as! NSDictionary){
//                print("fin!!",decoded.app)
//            }
//
//            print("test mock",testmock)
//
//            guard let children = snapshot.value as? Data else{
//                print("Error fetch message")
//                return
//            }
//            print("children",children)
//
//
//        }
//
//    }
    
    
    
    func fetchTest(){
        let requestURL:String = "https://dofavor-cb57e-default-rtdb.asia-southeast1.firebasedatabase.app/mocking"
        let headers: HTTPHeaders = ["Authorization" : "AIzaSyCDxrGWCWcl3wdgQ8siu3kQYEYjqdgMrDw",
                                    "Content-Type": "application/json"]
        let request = AF.request(requestURL, method: .get, headers: headers).responseString { response in
            
            //            print("AF.request",response)
            
        }
        
        //        print("request.data",request.response?.code )
        
        //        request.responseJSON{
        //            response in
        //
        //            switch(response.result){
        //            case .success:
        //                do{
        //                    print("response?.statusCode",response.value)
        //                }catch{
        //
        //                }
        //            case .failure:
        //                break
        //            }
        //        }
        
        
        
        request.responseDecodable(of: FirebaseMessage.self){ (response) in
            switch response.result{
            case .success(_):
                guard let data = response.value else {return}
                let petitionerID = data.petitioner
                let applicantID = data.applicant
                let messageData:[MessageModel] = data.message
                
                print("fetch test 1",petitionerID)
                print("fetch test 2",messageData)
                
                
            case .failure(let error):
                print("fetch test",error)
                print("response?.statusCode",response.response?.statusCode)
                print("response?.statusCode")
                print("petitioner404",response.value?.petitioner)
            }
        }
        
    }
    
}
