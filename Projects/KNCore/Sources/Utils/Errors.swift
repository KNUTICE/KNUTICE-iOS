//
//  Errors.swift
//  KNBookmark
//
//  Created by 이정훈 on 1/4/26.
//

import Foundation

public enum ExistingBookmarkError: Error {
    case alreadyExist(message: String)
}

public enum RemoteServerError: Error {
    case invalidResponse(message: String)
}

public enum UserInfoError: Error {
    case nttIdNotFound(message: String)
}
