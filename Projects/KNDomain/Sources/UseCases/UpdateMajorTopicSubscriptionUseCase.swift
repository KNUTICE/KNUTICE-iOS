//
//  UpdateMajorTopicSubscriptionUseCase.swift
//  KNDomain
//
//  Created by 이정훈 on 6/10/26.
//

import Foundation
import KNUtility

public actor AddMajorUseCase {
    private let repository: TopicSubscriptionRepository
    private var processingTask: Task<Void, Never>?
    private var continuation: AsyncStream<any CategoryProtocol>.Continuation?
    
    public init(repository: TopicSubscriptionRepository) {
        self.repository = repository
    }
    
    deinit {
        processingTask?.cancel()
        continuation?.finish()
    }
    
    public func execute(major: any CategoryProtocol) async throws {
        if processingTask == nil {
            startQueue()
        }
        continuation?.yield(major)
    }
    
    private func startQueue() {
        let (stream, continuation) = AsyncStream<any CategoryProtocol>.makeStream()
        self.continuation = continuation
        
        processingTask = Task {
            for await major in stream {
                do {
                    try await performUpdate(major: major)
                } catch {
                    print("Update failed: \(error)")
                }
            }
        }
    }
    
    private func performUpdate(major: any CategoryProtocol) async throws {
        // 학과 구독 여부
        let isSubscribed = await MajorNotificationManager.shared.isSubscribed
        // 선택된 학과
        // TODO: 1.8 버전 이후, 다중 학과 선택 변경 예정
        let majorStr = await MajorManager.shared.majorStrings.first
        
        // 이전에 선택된 학과를 서버에서 구독 해제
        if let majorStr, let subscribedMajor = MajorCategory(rawValue: majorStr), isSubscribed {
            try await repository.unsubscribe(of: .major, topic: subscribedMajor)
        }
        
        // 새로 선택한 학과 알림 구독
        if isSubscribed {
            try await repository.subscribe(of: .major, topic: major)
        }
        
        // UserDefaults에 선택한 학과 저장
        await MajorManager.shared.addMajor(major.rawValue)
    }
}
