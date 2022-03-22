//
//  doFavorApp.swift
//  doFavor
//
//  Created by Phakkharachate on 16/3/2565 BE.
//

import SwiftUI
import Firebase

@main
struct doFavorApp: App {
    @ObservedObject var rootView = RootView.shared
    
    init(rootView: AppViews) {
        self.rootView.viewId = rootView
    }
    
    init() {
        FirebaseApp.configure()
        AppUtils.saveDeviceUUIDToken(token: UIDevice.current.identifierForVendor!.uuidString)

        if(AppUtils.getUsrAuthToken() == nil || AppUtils.getUsrAuthToken() == "") {
            rootView.viewId = .LoginView
        }
        else{
            rootView.viewId = .MainAppView
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            if rootView.viewId == .LoginView {
                ContentView()
                    .environmentObject(rootView)
            }
            else {
                HomePage()
                    .environmentObject(rootView)
            }
        }
    }
}
