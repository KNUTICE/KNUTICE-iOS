//
//  Errors.swift
//  KNUTICE
//
//  Created by 이정훈 on 2/21/25.
//

import Foundation

enum RemoteServerError: Error {
    case invalidResponse(message: String)
}

enum ExistingBookmarkError: Error {
    case alreadyExist(message: String)
}

enum UserInfoError: Error {
    case nttIdNotFound(message: String)
}
