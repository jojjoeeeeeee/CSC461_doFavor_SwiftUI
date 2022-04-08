//
//  doFavorError.swift
//  doFavor
//
//  Created by Phakkharachate on 21/3/2565 BE.
//

import Foundation

enum ServiceError:Error {
    case UnParsableError
    case Non200StatusCodeError(doFavorAPIError)
    case BackEndError(errorMessage:String)
    case NoNetworkError
}

struct doFavorAPIError:Decodable {
    var message:String?
    var status:String?
}
