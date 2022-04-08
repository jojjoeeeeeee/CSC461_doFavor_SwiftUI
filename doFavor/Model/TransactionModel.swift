//
//  TransactionModel.swift
//  doFavor
//
//  Created by Phakkharachate on 7/4/2565 BE.
//

import Foundation

struct ResponseTSCTFormDataModel: Codable {
    let result: String
    let message: String
    let data: TSCTFormDataModel
}

struct TSCTFormDataModel: Codable {
    let landmark: [landmarkDataModel]?
    let type: [typeDataModel]?
}

struct landmarkDataModel: Codable {
    let name: String?
    let building: String?
    let latitude: Double?
    let longitude: Double?
}

struct typeDataModel: Codable {
    let title: String?
    let title_en: String?
    let detail: String?
}

struct RequestCreateTSCTModel: Encodable {
    var title: String?
    var detail: String?
    var type: String?
    var reward: String?
    var petitioner_id: String?
    var applicant_id: String?
    var conversation_id: String?
    var location: RequestLocationModel?
    var task_location: RequestTaskLocationModel?
}

struct RequestLocationModel: Encodable {
    var room: String?
    var floor: String?
    var building: String?
    var optional: String?
    var latitude: Double?
    var longitude: Double?
}

struct RequestTaskLocationModel: Encodable {
    var name: String?
    var building: String?
    var latitude: Double?
    var longitude: Double?
}

struct ResponseCreateTSCTModel: Codable {
    let result: String
    let message: String
    let data: CreateTSCTDataModel
}

struct CreateTSCTDataModel: Codable {
    let title: String?
    let detail: String?
    let type: String?
    let status: String?
}

class FormDataObservedModel: ObservableObject {
    @Published var landmark: [landmarkDataModel]?
    @Published var type: [typeDataModel]?
}
