//
//  doFavorError.swift
//  doFavor
//
//  Created by Phakkharachate on 21/3/2565 BE.
//

import Foundation

public enum ServiceError:Error {
    case UnParsableError
    case Non200StatusCodeError(doFavorAPIError)
    case BackEndError(errorMessage:String)
    case NoNetworkError
}

public enum MessageError:Error {
    case ConversationNotFound
    case MessageNotFound
}

public struct doFavorAPIError:Decodable {
    var message:String?
    var status:String?
}

public enum StorageErrors: Error {
    case failedToUpload
    case failedToGetDownloadUrl
}
