//
//  Errors.swift
//  KNUTICE
//
//  Created by 이정훈 on 2/21/25.
//

import Foundation

public enum RemoteServerError: Error {
    case invalidResponse(message: String)
}

public enum NetworkError: Error {
    case remoteServerError(message: String)
    case invalidURL(message: String)
}

public enum ExistingBookmarkError: Error {
    case alreadyExist(message: String)
}

public enum UserInfoError: Error {
    case nttIdNotFound(message: String)
}

public enum TokenError: Error {
    case notFound
}
