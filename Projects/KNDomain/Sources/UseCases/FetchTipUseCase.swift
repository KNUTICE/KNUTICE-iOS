//
//  FetchTipUseCase.swift
//  KNTip
//
//  Created by 이정훈 on 1/6/26.
//

import Foundation

public protocol FetchTipUseCase: Actor {
    func execute() async -> Result<[Tip]?, any Error>
}

public actor FetchTipUseCaseImpl: FetchTipUseCase {
    private let repository: TipRepository
    
    public init(repository: TipRepository) {
        self.repository = repository
    }
    
    public func execute() async -> Result<[Tip]?, any Error> {
        return await repository.fetchTips()
    }
}
