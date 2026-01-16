//
//  Container+Instance.swift
//  KNToken
//
//  Created by 이정훈 on 1/6/26.
//

import Factory

public extension Container {
    var registerFCMTokenUseCase: Factory<RegisterFCMTokenUseCase> {
        Factory(self) {
            RegisterFCMTokenUseCaseImpl()
        }
    }
    
    var updateFCMTokenUseCase: Factory<UpdateFCMTokenUseCase> {
        Factory(self) {
            UpdateFCMTokenUseCaseImpl()
        }
    }
}
