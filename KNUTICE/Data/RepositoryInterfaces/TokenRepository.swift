//
//  TokenRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/8/24.
//

import RxSwift

protocol TokenRepository {
    func registerToken(token: String) -> Observable<Bool>
}
