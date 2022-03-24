//
//  AppViews.swift
//  doFavor
//
//  Created by Phakkharachate on 22/3/2565 BE.
//

import Foundation

enum AppViews {
    case LoginView
    case MainAppView
    case GiverView
    case ReceiverView
}


class RootView: ObservableObject {
    
    static let shared = RootView(showingView: .LoginView)
    
    init(showingView: AppViews) {
        self.viewId = showingView
    }
    
    @Published var viewId : AppViews
}
