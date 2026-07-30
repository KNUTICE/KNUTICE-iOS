//
//  MigrateBookmarkTopicsUseCase.swift
//  KNDomain
//
//  Created by 이정훈 on 7/8/26.
//

import Foundation
import KNUtility

public final class MigrateBookmarkTopicsUseCase: Sendable {
    private let bookmarkRepository: BookmarkRepository
    private let noticeRepository: NoticeRepository
    private let swiftDataBookmarkRepository: BookmarkRepository
    
    public init(
        bookmarkRepository: BookmarkRepository,
        noticeRepository: NoticeRepository,
        swiftDataBookmarkRepository: BookmarkRepository
    ) {
        self.bookmarkRepository = bookmarkRepository
        self.noticeRepository = noticeRepository
        self.swiftDataBookmarkRepository = swiftDataBookmarkRepository
    }
    
    /// Migrates stored bookmarks to the SwiftData repository using the latest notice data, then marks the migration as completed.
    ///
    /// - Throws: An error if the task is cancelled or if fetching, saving, or deleting bookmarks fails.
    public func execute() async throws {
        try Task.checkCancellation()
        
        // 기존 저장소에 저장되어 있는 Bookmark 전체 조회
        let storedBookmarks = try await bookmarkRepository.fetchAll()
        
        // 각 Bookmark의 notice id로 최신 Notice 정보를 병렬 조회
        try await withThrowingTaskGroup(of: Bookmark.self) { group in
            for bookmark in storedBookmarks {
                group.addTask {
                    try Task.checkCancellation()
                    
                    // Notice 조회에 실패해 값이 없으면 기존 Bookmark 정보 유지
                    guard let notice = try await self.noticeRepository.fetchNotice(by: bookmark.id) else {
                        return bookmark
                    }
                    
                    // 최신 Notice 정보에 기존 메모와 알림 날짜를 유지한 Bookmark 생성
                    return Bookmark(
                        notice: notice,
                        memo: bookmark.memo,
                        alarmDate: bookmark.alarmDate
                    )
                }
            }
            
            // 갱신된 Bookmark를 SwiftData 저장소에 순차 저장
            for try await bookmark in group {
                try Task.checkCancellation()

                let alreadyMigrated = try await swiftDataBookmarkRepository.fetch(id: bookmark.id) != nil

                if !alreadyMigrated {
                    try await swiftDataBookmarkRepository.save(bookmark: bookmark)
                }
                
                // 마이그레이션 완료된 Bookmark는 기존 저장소에서 삭제
                try await bookmarkRepository.delete(by: bookmark.id)
            }
        }
        
        // Bookmark 마이그레이션 플래그 변수 업데이트
        UserDefaults.shared?.set(true, forKey: UserDefaultsKeys.hasMigratedBookmarkTopics.rawValue)
    }
}
