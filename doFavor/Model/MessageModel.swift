//
//  MessageModel.swift
//  doFavor
//
//  Created by Khing Thananut on 21/4/2565 BE.
//

import SwiftUI

struct FirebaseMessage: Codable{
    var petitioner: String
    var applicant: String
    var message: [MessageModel]
}

struct MessageModel: Codable {
    var content: String
    var date: Date
    var type: String
    var sender: String
}

struct mocking: Codable {
    var app: String
    var pet: String
}

class FirebaseMessageObservedModel: ObservableObject{
    @Published var data: FirebaseMessage?
}

