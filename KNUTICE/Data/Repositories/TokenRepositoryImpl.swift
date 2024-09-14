//
//  TokenRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/8/24.
//

import RxSwift
import Foundation

final class TokenRepositoryImpl: TokenRepository {
    private let dataSource: TokenDataSource
    
    init(dataSource: TokenDataSource) {
        self.dataSource = dataSource
    }
    
    func registerToken(token: String) -> Observable<Bool> {
        let remoteURL = Bundle.main.tokenURL
        let params = [
            "deviceToken": token
        ]
        
        return dataSource.sendPostRequest(to: remoteURL, params: params)
            .map {
                if let statusCode = try? $0.get().result.resultCode, statusCode == 200 {
                    return true
                }
                
                return false
            }
    }
}
