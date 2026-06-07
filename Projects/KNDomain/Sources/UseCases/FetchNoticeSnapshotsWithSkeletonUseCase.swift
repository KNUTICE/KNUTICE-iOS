//
//  FetchNoticeSnapshotsWithSkeletonUseCase.swift
//  KNDomain
//
//  Created by 이정훈 on 6/7/26.
//

import Foundation

public final class FetchNoticeSnapshotsWithSkeletonUseCase: NoticeSnapshotCreatable, Sendable {
    private let fetchNoticeSnapshotsUseCase: FetchNoticeSnapshotsUseCase
    
    public init(fetchNoticeSnapshotsUseCase: FetchNoticeSnapshotsUseCase) {
        self.fetchNoticeSnapshotsUseCase = fetchNoticeSnapshotsUseCase
    }
    
    public func execute(
        category: some CategoryProtocol,
        after nttId: Int? = nil,
        size: Int = 20
    ) -> AsyncThrowingStream<MainSectionNotice, Error> {
        AsyncThrowingStream { continuation in
            let task = Task {
                do {
                    // 스켈레톤을 위한 Mock 데이터 전달
                    let skeletonData = makeSectionNotice(
                        category: category,
                        snapshots: Notice.skeletonNotices().map { createSnapshot(from: $0) },
                        presentationType: .skeleton
                    )
                    continuation.yield(skeletonData)
                    
                    try Task.checkCancellation()
                    
                    // NoticeSnapshot 가져오기
                    let snapshots = try await fetchNoticeSnapshotsUseCase.execute(category: category, after: nttId, size: size)
                    let sectionNotice = makeSectionNotice(
                        category: category,
                        snapshots: snapshots,
                        presentationType: .actual
                    )
                    
                    continuation.yield(sectionNotice)
                    
                    // 스트림 종료
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            
            continuation.onTermination = { _ in
                // Stream 종료 시 Task도 함께 취소
                task.cancel()
            }
        }
    }
    
    private func makeSectionNotice(
        category: some CategoryProtocol,
        snapshots: [NoticeSnapshot],
        presentationType: MainNotice.PresentationType
    ) -> MainSectionNotice {
        MainSectionNotice(
            header: category.localizedDescription,
            category: category,
            items: snapshots.map {
                MainNotice(
                    presentationType: presentationType,
                    noticeSnapshot: $0
                )
            }
        )
    }
}
