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
        
        if AppUtils.isAppFirstRun() {
                    AppUtils.E2EE.generateKeyPair()
                }


        if(AppUtils.getUsrAuthToken() == nil || AppUtils.getUsrAuthToken() == "") {
            rootView.viewId = .LoginView
        }
        else{
            rootView.viewId = .MainAppView
        }
        
        //Remove app firstrun
//        UserDefaults.standard.removeObject(forKey: "isapp_firstrun")
        AppUtils.setAppFirstRun()

    }
    
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            if rootView.viewId == .LoginView {
                ContentView()
                    .environmentObject(rootView)
            }
            else if rootView.viewId == .GiverView {
                GiverMainPage()
                    .environmentObject(rootView)
                    .transition(.slide)
            }
            else if rootView.viewId == .ReceiverView {
                ReceiverRequestPage()
                    .environmentObject(rootView)
                    .transition(.move(edge: .bottom))
            }
            else if rootView.viewId == .SettingView {
                SettingMainPage()
                    .environmentObject(rootView)
            }
            else {
                HomePage()
                    .environmentObject(rootView)
            }
        }
    }
}
