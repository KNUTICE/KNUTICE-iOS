//
//  TokenRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/8/24.
//

import Combine
import RxSwift

protocol TokenRepository {
    func registerToken(token: String) -> Observable<Bool>
    
    @discardableResult
    func register(token: String) async throws -> Bool
    
    func getFCMToken() -> AnyPublisher<String, any Error>
    func getFCMToken() async throws -> String
}
