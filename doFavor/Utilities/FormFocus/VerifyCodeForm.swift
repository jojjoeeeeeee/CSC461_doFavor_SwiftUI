//
//  VerifyCodeForm.swift
//  doFavor
//
//  Created by Phakkharachate on 22/3/2565 BE.
//

import Focuser

enum VerifyCodeFormFields {
    case vfc1,vfc2,vfc3,vfc4,vfc5,vfc6
}

extension VerifyCodeFormFields: FocusStateCompliant {
    
    static var last : VerifyCodeFormFields {
        .vfc6
    }
    
    var next: VerifyCodeFormFields? {
        switch self {
        case .vfc1:
            return .vfc2
        case .vfc2:
            return .vfc3
        case .vfc3:
            return .vfc4
        case .vfc4:
            return .vfc5
        case .vfc5:
            return .vfc6
        default: return nil
        }
    }
}
