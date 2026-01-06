//
//  Errors.swift
//  KNNetwork
//
//  Created by 이정훈 on 1/3/26.
//

import Foundation

public enum TokenError: Error {
    case notFound
}

public enum NetworkError: Error {
    case remoteServerError(message: String)
    case invalidURL(message: String)
}
