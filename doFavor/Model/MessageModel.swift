//
//  MessageModel.swift
//  doFavor
//
//  Created by Khing Thananut on 21/4/2565 BE.
//

import SwiftUI

struct FirebaseMessage: Codable{
    var petitioner: FirebaseUserModel?
    var applicant: FirebaseUserModel?
    var message: [MessageModel]?
}

struct FirebaseUserModel: Codable {
    var id: String?
    var firstname: String?
    var lastname: String?
    var publicKey: String?
}

struct MessageModel: Codable {
    var content: String?
    var date: String?
    var type: String?
    var sender: String?
}


class FirebaseMessageObservedModel: ObservableObject{
    @Published var data: FirebaseMessage?
}

