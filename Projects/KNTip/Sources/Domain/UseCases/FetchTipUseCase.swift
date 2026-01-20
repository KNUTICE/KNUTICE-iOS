//
//  FetchTipUseCase.swift
//  KNTip
//
//  Created by 이정훈 on 1/6/26.
//

import Factory

public protocol FetchTipUseCase: Actor {
    func execute() async -> Result<[Tip]?, any Error>
}

public actor FetchTipUseCaseImpl: FetchTipUseCase {
    @Injected(\.tipRepository) private var repository
    
    public init() {}
    
    public func execute() async -> Result<[Tip]?, any Error> {
        return try await repository.fetchTips()
    }
}
