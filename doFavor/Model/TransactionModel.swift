//
//  TransactionModel.swift
//  doFavor
//
//  Created by Phakkharachate on 7/4/2565 BE.
//

import Foundation
import CoreLocation

struct ResponseTSCTFormDataModel: Codable {
    let result: String
    let message: String
    let data: TSCTFormDataModel
}

struct TSCTFormDataModel: Codable {
    let landmark: [landmarkDataModel]?
    let type: [typeDataModel]?
}

struct ResponseTSCTHistoryDataModel: Codable {
    let result: String
    let message: String
    let data: historyModel
}

struct historyModel: Codable {
    let history: [historyDataModel]?
}

struct historyDataModel: Codable {
    let id: String?
    let title: String?
    let detail: String?
    let type: String?
    let reward: String?
    let petitioner_id: String?
    let applicant_id: String?
    let conversation_id: String?
    let status: String?
    let location: userLocationDataModel?
    let task_location: landmarkDataModel?
    let role: String?
    let created: String?
}

struct userLocationDataModel: Codable {
    let room: String?
    let floor: String?
    let building: String?
    let optional: String?
    let latitude: Double?
    let longitude: Double?
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

struct RequestGetTSCTModel: Encodable {
    var transaction_id: String?
}

struct ResponseGetTSCTDataModel: Codable {
    let result: String
    let message: String
    let data: TSCTDataModel
}

struct RequestReportTSCTModel: Encodable {
    var transaction_id: String?
    var detail: String?
}

struct ResponseReportTSCTDataModel: Codable {
    let result: String
    let message: String
    let data: ReportTSCTDataModel
}

struct ReportTSCTDataModel: Codable {
    let transaction_id: String?
    let detail: String?
    let report_owner: String?
}

struct TSCTDataModel: Codable {
    let id: String?
    let title: String?
    let detail: String?
    let type: String?
    let reward: String?
    let petitioner: ResponseUserTSCT?
    let applicant: ResponseUserTSCT?
    let conversation_id: String?
    let status: String?
    let location: userLocationDataModel?
    let task_location: landmarkDataModel?
    var isAccepted: Bool?
    let created: String?
}

struct ResponseUserTSCT: Codable {
    let id: String?
    let firstname: String?
    let lastname: String?
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
    let conversation_id: String?
}

struct ResponseGetAllTSCTDataModel: Codable {
    let result: String
    let message: String
    let data: getAllModel
}

struct getAllModel: Codable {
    let transactions: [getAllDataModel]?
}

struct getAllDataModel: Codable {
    let id: String?
    let title: String?
    let detail: String?
    let type: String?
    let reward: String?
    let petitioner_id: String?
    let applicant_id: String?
    let conversation_id: String?
    let status: String?
    let location: userLocationDataModel?
    let task_location: landmarkDataModel?
    var distance: CLLocationDistance?
    var distanceString: String?
    let created: String?
}

class FormDataObservedModel: ObservableObject {
    @Published var landmark: [landmarkDataModel]?
    @Published var type: [typeDataModel]?
}

class HistoryDataObservedModel: ObservableObject {
    @Published var history: [historyDataModel]?
}

class AllDataObservedModel: ObservableObject {
    @Published var transactions: [getAllDataModel]?
}

class TSCTDataObservedModel: ObservableObject {
    @Published var data: TSCTDataModel?
}

