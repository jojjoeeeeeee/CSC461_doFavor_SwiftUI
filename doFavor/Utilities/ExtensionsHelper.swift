//
//  ExtensionsHelper.swift
//  doFavor
//
//  Created by Phakkharachate on 16/3/2565 BE.
//

import Foundation
//MARK: String Class Extension Helper

extension String {
    
    public var numberFormat:String {
       let numberFormatter = NumberFormatter()
       numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: Int(self) ?? 0 )) ?? ""
   }
    
}
