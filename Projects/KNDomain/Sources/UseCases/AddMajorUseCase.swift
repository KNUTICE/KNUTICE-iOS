//
//  UpdateMajorTopicSubscriptionUseCase.swift
//  KNDomain
//
//  Created by 이정훈 on 6/10/26.
//

import Foundation
import KNUtility

public actor AddMajorUseCase {
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
    
    public func execute(major: any CategoryProtocol) async throws {
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
        // 선택된 학과
        // TODO: 1.8 버전 이후, 다중 학과 선택 변경 예정
        let majorID = await MajorManager.shared.majorIDs.first
        
        if let majorID {
            
            // 이전에 선택된 학과를 서버에서 구독 해제
            if isSubscribed {
                try await repository.unsubscribe(of: .major, topicID: majorID)
            }
            
            // 이전에 선택된 학과를 UserDefaults에서 삭제
            await MajorManager.shared.remove(id: majorID)
        }
        
        // 새로 선택한 학과 알림 구독
        if isSubscribed {
            try await repository.subscribe(of: .major, topicID: major.id)
        }
        
        // UserDefaults에 선택한 학과 저장
        await MajorManager.shared.add(id: major.id)
        
    }
}
