//
//  ExtensionsHelper.swift
//  doFavor
//
//  Created by Phakkharachate on 16/3/2565 BE.
//

import Foundation
import UIKit
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//MARK: TextLimit Binding
class TextBindingManager: ObservableObject {
    
    let characterLimit: Int
    
    init(limit: Int = 1) {
        characterLimit = limit
    }
    
    @Published var text = ""
    
}

//MARK: String Class Extension Helper

extension String {
    
    public var numberFormat:String {
       let numberFormatter = NumberFormatter()
       numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: Int(self) ?? 0 )) ?? ""
   }
    
    func matchRegex(for regex: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: regex, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
}

struct dateFormat {
    func stringToDate(date:String) -> Date {
        let formatter = DateFormatter()

        // Format 1
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let parsedDate = formatter.date(from: date) {
          return parsedDate
        }

        // Format 2
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSSZ"
        if let parsedDate = formatter.date(from: date) {
          return parsedDate
        }

        // Couldn't parsed with any format. Just get the date
        let splitedDate = date.components(separatedBy: "T")
        if splitedDate.count > 0 {
          formatter.dateFormat = "yyyy-MM-dd"
            if let parsedDate = formatter.date(from: splitedDate[0]) {
            return parsedDate
          }
        }

        // Nothing worked!
        return Date()
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

}

extension View {
    public func currentDeviceNavigationViewStyle() -> AnyView {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return AnyView(self.navigationViewStyle(DefaultNavigationViewStyle()))
        } else {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        }
    }
    
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
