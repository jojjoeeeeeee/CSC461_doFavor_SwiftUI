//
//  Constants.swift
//  doFavor
//
//  Created by Phakkharachate on 16/3/2565 BE.
//

import Foundation
import SwiftUI

struct Constants {
    static let BASE_URL = "https://swuhelp.herokuapp.com/api"
//    static let BASE_URL = "http://192.168.1.36:8080/api"
    static let ENDPOINT = "https://swuhelp.herokuapp.com/"
    static let AUTH_REGISTER = "/auth/register"
    static let AUTH_LOGIN = "/auth/login"
    static let AUTH_VERIFY = "/auth/verify"
    static let AUTH_VERIFY_RESEND = "/auth/verify/resend"
    
    static let TSCT_FORM_DATA = "/transaction/data"
    static let TSCT_CREATE = "/transaction/create"
    static let TSCT_GET_HISTORY = "/transaction/history"
    static let TSCT_GET_PETITIONER = "/transaction/get/petitioner"
    static let TSCT_GET_APPLICANT = "/transaction/get/applicant"
    static let TSCT_GET_ALL = "/transaction/get/all"
    static let TSCT_ACCEPT = "/transaction/accept"
    static let TSCT_CANCEL_PETITIONER = "/transaction/cancel/petitioner"
    static let TSCT_CANCEL_APPLICANT = "/transaction/cancel/applicant"
    static let TSCT_SUCCESS = "/transaction/success"
    static let TSCT_REPORT = "/transaction/report"
    
    static let FILE_UPLOAD_CONVERSATION_IMAGE = "/file/upload/img/conversation"
    
    struct AppConstants {
        static let CUR_USR_TOKEN = "UserAuthToken"
        static let CUR_USR_USERNAME = "UserUsername"
        static let CUR_USR_EMAIL = "UserEmail"
        static let CUR_USR_PROFILE = "UserProfile"
        static let CUR_USR_NAME = "UserName"
        static let CUR_USR_ADDRESS = "UserAddress"
    }
}

//struct Colors{
//    static let black = UIColor(red: 68/255, green: 57/255, blue: 57/255, alpha: 1) as Color
//    static let darkred = UIColor(red: 202/255, green: 114/255, blue: 114/255, alpha: 1) as Color
//    static let grey = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1) as Color
//}

extension Color {
    static let darkest = Color(UIColor(red: 68/255, green: 57/255, blue: 57/255, alpha: 1))
    static let darkred = Color(UIColor(red: 202/255, green: 114/255, blue: 114/255, alpha: 1))
    static let grey = Color(UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1))

}
