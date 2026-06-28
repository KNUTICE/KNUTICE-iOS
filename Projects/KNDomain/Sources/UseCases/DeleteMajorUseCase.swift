//
//  DeleteMajorUseCase.swift
//  KNDomain
//
//  Created by 이정훈 on 6/16/26.
//

import Foundation
import KNUtility

public actor DeleteMajorUseCase {
    // stream item: (처리할 카테고리, 결과를 전달할 continuation)
    private typealias WorkItem = (any CategoryProtocol, CheckedContinuation<Void, Error>)
    
    private let repository: TopicSubscriptionRepository
    private var processingTask: Task<Void, Never>?
    private var continuation: AsyncStream<WorkItem>.Continuation?
    
    public init(repository: TopicSubscriptionRepository) {
        self.repository = repository
    }
    
    deinit {
        processingTask?.cancel()
        continuation?.finish()
    }
    
    public func execute(for major: MajorCategory) async throws {
        if processingTask == nil {
            startQueue()
        }
        
        // withCheckedThrowingContinuation을 통해 작업 결과를 동기적으로 기다림
        try await withCheckedThrowingContinuation { continuation in
            self.continuation?.yield((major, continuation))
        }
    }
    
    private func startQueue() {
        let (stream, continuation) = AsyncStream<WorkItem>.makeStream()
        self.continuation = continuation
        
        processingTask = Task {
            for await (major, continuation) in stream {
                do {
                    try await performUpdate(major: major)
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func performUpdate(major: any CategoryProtocol) async throws {
        // 학과 구독 여부
        let isSubscribed = await MajorNotificationManager.shared.isSubscribed
        
        // 서버에 구독 되어 있는 학과 topic 삭제
        if let subscribedMajor = major as? MajorCategory, isSubscribed {
            try await repository.unsubscribe(of: .major, topic: subscribedMajor)
        }
        
        // UserDefaults에 선택한 학과 삭제
        await MajorManager.shared.removeMajor(major.topic)
    }
}
