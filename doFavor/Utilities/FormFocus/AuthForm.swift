//
//  AuthForm.swift
//  doFavor
//
//  Created by Phakkharachate on 23/3/2565 BE.
//

import Focuser

enum SignInFormFields {
    case buasri,pwd
}

extension SignInFormFields: FocusStateCompliant {
    
    static var last : SignInFormFields {
        .pwd
    }
    
    var next: SignInFormFields? {
        switch self {
        case .buasri:
            return .pwd
        default: return nil
        }
    }
}

enum SignUpFormFields {
    case buasri,fname,lname,email,pwd,cfpwd
}

extension SignUpFormFields: FocusStateCompliant {
    
    static var last : SignUpFormFields {
        .cfpwd
    }
    
    var next: SignUpFormFields? {
        switch self {
        case .buasri:
            return .fname
        case .fname:
            return .lname
        case .lname:
            return .email
        case .email:
            return .pwd
        case .pwd:
            return .cfpwd
        default: return nil
        }
    }
}
