//
//  doFavorApp.swift
//  doFavor
//
//  Created by Phakkharachate on 16/3/2565 BE.
//

import SwiftUI

@main
struct doFavorApp: App {
    
    init() {
        AppUtils.saveDeviceUUIDToken(token: UIDevice.current.identifierForVendor!.uuidString)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
