//
//  MockTokenRepository.swift
//  KNTokenTests
//
//  Created by 이정훈 on 3/27/26.
//

import Foundation
import KNNetwork
@testable import KNToken

actor MockTokenRepository: TokenRepository {
    let shouldThrowError: Bool
    
    init(shouldThrowError: Bool = false) {
        self.shouldThrowError = shouldThrowError
    }
    
    func register() async throws {
        if shouldThrowError {
            throw NetworkError.remoteServerError(message: "Registration Failed")
        }
    }
    
    func update(oldFCMToken: String?, newFCMToken: String) async throws {
        if shouldThrowError {
            throw NetworkError.remoteServerError(message: "Update Failed")
        }
    }
}
