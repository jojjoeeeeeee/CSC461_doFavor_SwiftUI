//
//  UserModel.swift
//  doFavor
//
//  Created by Phakkharachate on 21/3/2565 BE.
//

import Foundation

struct RequestRegisterUserModel: Encodable {
    var username: String?
    var password: String?
    var email: String?
    var name: RequestNameModel?
    var profile_pic: String?
    var device_id: String?
}

struct RequestLoginUserModel: Encodable {
    var username: String?
    var password: String?
    var device_id: String?
}


struct RequestNameModel: Encodable {
    var firstname: String?
    var lastname: String?
}

struct RequestOtpModel: Encodable {
    var email: String?
    var otp: String?
    var device_id: String?
}

struct ResponseUserModel: Codable {
    let result: String
    let message: String
    let data: UserModel
}

struct UserModel: Codable {
    let username: String?
    let email: String?
    let profile_pic: String?
    let name: NameModel?
    let state: String?
    let device_id: String?
}

struct NameModel: Codable {
    var firstname: String?
    var lastname: String?
}

struct RequestReportModel: Encodable {
    var email: String?
    var detail: String?
}

struct ResponseReportDataModel: Codable {
    let result: String
    let message: String
    let data: ReportDataModel
}

struct ReportDataModel: Codable {
    let email: String?
    let detail: String?
    let report_owner: String?
}


class UserObservedModel: ObservableObject {
    @Published var username: String?
    @Published var email: String?
    @Published var profile_pic: String?
    @Published var name: NameModel?
}
