//
//  KeyboardInfo.swift
//  doFavor
//
//  Created by Phakkharachate on 23/4/2565 BE.
//

import UIKit
import SwiftUI

public class KeyboardInfo: ObservableObject {

    public static var shared = KeyboardInfo()

    @Published public var height: CGFloat = 0

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardChanged(notification: Notification) {
        if notification.name == UIApplication.keyboardWillHideNotification {
            self.height = 0
        } else {
            self.height = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0)
        }
    }

}

struct KeyboardAware: ViewModifier {
    
    @State var multiplier: CGFloat
    @ObservedObject private var keyboard = KeyboardInfo.shared

    func body(content: Content) -> some View {
        if (multiplier==0.95) {
            content
                .padding(.bottom, self.keyboard.height*multiplier)
//                .edgesIgnoringSafeArea(self.keyboard.height > 0 ? .bottom : [])
                .ignoresSafeArea(.keyboard)
                .animation(.easeOut)
        } else {
            content
                .padding(.bottom, self.keyboard.height*multiplier)
                .ignoresSafeArea(.keyboard)
                .animation(.easeOut)
        }
        
    }
}

extension View {
    
    public func keyboardAware(multiplier: CGFloat) -> some View {
        ModifiedContent(content: self, modifier: KeyboardAware(multiplier: multiplier))
    }
}


