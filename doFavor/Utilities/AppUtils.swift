//
//  AppUtils.swift
//  doFavor
//
//  Created by Phakkharachate on 21/3/2565 BE.
//

import Foundation

struct AppUtils {
    
    fileprivate static let UD_Device_uuid = "device_uuid"
    
    static func saveDeviceUUIDToken(token:String) {
        UserDefaults.standard.setValue(token, forKey: UD_Device_uuid)
    }
    
    static func getDeviceUUIDToken() -> String? {
        return UserDefaults.standard.value(forKey: UD_Device_uuid) as? String
    }
    
    static func saveUsrAuthToken(token:String) {
        UserDefaults.standard.setValue(token, forKey: Constants.AppConstants.CUR_USR_TOKEN)
    }
    
    static func getUsrAuthToken() -> String? {
        return UserDefaults.standard.value(forKey: Constants.AppConstants.CUR_USR_TOKEN) as? String
    }
    
    static func saveUsrId(id:String) {
        UserDefaults.standard.setValue(id, forKey: Constants.AppConstants.CUR_USR_ID)
    }
    
    static func getUsrId() -> String? {
        return UserDefaults.standard.value(forKey: Constants.AppConstants.CUR_USR_ID) as? String
    }
    
    static func saveUsrUsername(username:String) {
        UserDefaults.standard.setValue(username, forKeyPath: Constants.AppConstants.CUR_USR_USERNAME)
    }
    
    static func getUsrUsername() -> String? {
        return UserDefaults.standard.value(forKey: Constants.AppConstants.CUR_USR_USERNAME) as? String
    }
    
    static func saveUsrEmail(email:String) {
        UserDefaults.standard.setValue(email, forKeyPath: Constants.AppConstants.CUR_USR_EMAIL)
    }
    
    static func getUsrEmail() -> String? {
        return UserDefaults.standard.value(forKey: Constants.AppConstants.CUR_USR_EMAIL) as? String
    }
    
    static func saveUsrProfile(profile:String) {
        UserDefaults.standard.setValue(profile, forKeyPath: Constants.AppConstants.CUR_USR_PROFILE)
    }
    
    static func getUsrProfile() -> String? {
        return UserDefaults.standard.value(forKey: Constants.AppConstants.CUR_USR_PROFILE) as? String
    }
    
    static func saveUsrName(firstname:String, lastname:String) {
        UserDefaults.standard.setValue("\(firstname) \(lastname)", forKeyPath: Constants.AppConstants.CUR_USR_NAME)
    }
    
    static func getUsrName() -> String? {
        return UserDefaults.standard.value(forKey: Constants.AppConstants.CUR_USR_NAME) as? String
    }
}
