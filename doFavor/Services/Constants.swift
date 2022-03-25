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
    
    struct AppConstants {
        static let CUR_USR_TOKEN = "UserAuthToken"
        static let CUR_USR_USERNAME = "UserUsername"
        static let CUR_USR_EMAIL = "UserEmail"
        static let CUR_USR_PROFILE = "UserProfile"
        static let CUR_USR_NAME = "UserName"
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


func testMessage() {
        let publicPem = UserDefaults.standard.value(forKey: "publicKey") as? String
        let privatePem = UserDefaults.standard.value(forKey: "privateKey") as? String
        
        AppUtils.E2EE.encryptMessage(message: "Test message", publicPem: publicPem ?? "") { result in
            switch result{
            case .success(let message):
                print("VALUE",message)
            case .failure(let err):
                print("Error",err)
            }
        }
        
        AppUtils.E2EE.decryptMessage(base64String: "qoKfQt/LQM5adx22ye7vK367m7CwBUtgGKxTiu7z348DHhukH73zJCBOpwIoSTwYhG776MxdAQYuGNO0JdawdH/5sygYGtOFDSSyUq775pjPt+3s92paq3tQ5HvwvS2VBZ5IyzXNQLLeTIEFDHmRW1V36/9Ng/nG02eftul1I7oaDY2hssFazcLpRFtVEi1IxULG5jTLxUtem+AAT6im8+L77KF9WMV8Iqe9JnTc84ToBBBsxJN9kDiOlZ0d9WbBBa0NO+X97JcxloWv9uuGoO9cAU+z6AwXQWmvVho17bTWXnrUNwrnycmQMhqaWGMVdymIZp32ke6rGmbVCtYbgg==", privatePem: privatePem ?? "") { result in
            switch result{
            case .success(let message):
                print("VALUE",message)
            case .failure(let err):
                print("Error",err)
            }
        }
    }
