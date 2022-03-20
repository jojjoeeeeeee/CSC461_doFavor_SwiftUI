//
//  AppUtils.swift
//  doFavor
//
//  Created by Phakkharachate on 21/3/2565 BE.
//

import Foundation

struct AppUtils {
    fileprivate static let UD_Auth_Token = "auth_token"
    fileprivate static let UD_Device_uuid = "device_uuid"
    
    static func saveDeviceUUIDToken(token:String) {
        UserDefaults.standard.setValue(token, forKey: UD_Device_uuid)
    }
    
    static func getDeviceUUIDToken() -> String? {
        return UserDefaults.standard.value(forKey: UD_Device_uuid) as? String
    }
}
