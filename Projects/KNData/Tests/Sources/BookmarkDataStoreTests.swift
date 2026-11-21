import Foundation
@testable import KNData
import KNUtility
import SwiftData
import Testing

@Suite("SwiftData 북마크 저장소")
struct BookmarkDataStoreTests {
    @Test("저장한 공지와 사용자 정보가 actor 경계를 넘어 값으로 보존된다")
    func roundTrip() async throws {
        let store = try makeStore()
        let alarmDate = Date(timeIntervalSince1970: 1_800_000_000)
        let bookmark = makeBookmark(alarmDate: alarmDate)

        try await store.save(bookmark)

        let fetched = try #require(await store.fetch(id: bookmark.notice.id))
        #expect(fetched.notice.id == bookmark.notice.id)
        #expect(fetched.notice.title == bookmark.notice.title)
        #expect(fetched.notice.contentURL == bookmark.notice.contentURL)
        #expect(fetched.notice.isSummarizable == bookmark.notice.isSummarizable)
        #expect(fetched.notice.department == bookmark.notice.department)
        #expect(fetched.notice.uploadDate == bookmark.notice.uploadDate)
        #expect(fetched.notice.imageURL == bookmark.notice.imageURL)
        #expect(fetched.notice.topicId == bookmark.notice.topicId)
        #expect(fetched.memo == bookmark.memo)
        #expect(fetched.alarmDate == alarmDate)

        let page = try await store.fetch(sortBy: .createdAtAscending, fetchLimit: 1, fetchOffset: 0)
        #expect(page.count == 1)
        let search = try await store.fetch(keyword: bookmark.notice.title, fetchLimit: nil, fetchOffset: 0)
        #expect(search.count == 1)

        try await store.update(id: bookmark.notice.id, memo: "수정한 메모", alarmDate: nil)
        let updated = try #require(await store.fetch(id: bookmark.notice.id))
        #expect(updated.memo == "수정한 메모")
        #expect(updated.alarmDate == nil)
        #expect(updated.notice.contentURL == bookmark.notice.contentURL)

        try await store.delete(id: bookmark.notice.id)
        #expect(try await store.fetch(id: bookmark.notice.id) == nil)
    }

    @Test("선택적 공지 필드와 알림 날짜의 nil이 유지된다")
    func optionalFields() async throws {
        let store = try makeStore()
        let original = makeBookmark()
        let bookmark = StoredBookmark(
            notice: StoredNotice(
                id: original.notice.id,
                title: original.notice.title,
                contentURL: nil,
                isSummarizable: original.notice.isSummarizable,
                department: nil,
                uploadDate: original.notice.uploadDate,
                imageURL: nil,
                topicId: original.notice.topicId
            ),
            memo: "",
            alarmDate: nil
        )

        try await store.save(bookmark)
        let fetched = try #require(await store.fetch(id: bookmark.notice.id))
        #expect(fetched.notice.contentURL == nil)
        #expect(fetched.notice.department == nil)
        #expect(fetched.notice.imageURL == nil)
        #expect(fetched.memo.isEmpty)
        #expect(fetched.alarmDate == nil)
    }

    @Test("같은 공지의 동시 저장은 한 번만 성공한다")
    func concurrentDuplicateSave() async throws {
        let store = try makeStore()
        let bookmark = makeBookmark()
        let attempts = (0..<2).map { _ in
            Task { try await store.save(bookmark) }
        }

        var successCount = 0
        var duplicateCount = 0
        for attempt in attempts {
            do {
                try await attempt.value
                successCount += 1
            } catch let error as ExistingBookmarkError {
                switch error {
                case .alreadyExist:
                    duplicateCount += 1
                }
            }
        }

        #expect(successCount == 1)
        #expect(duplicateCount == 1)
        let bookmarks = try await store.fetch(sortBy: .createdAtAscending, fetchLimit: nil, fetchOffset: 0)
        #expect(bookmarks.count == 1)
    }

    private func makeStore() throws -> BookmarkDataStore {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: BookmarkModel.self, configurations: configuration)
        return BookmarkDataStore(modelContainer: container)
    }

    private func makeBookmark(alarmDate: Date? = nil) -> StoredBookmark {
        StoredBookmark(
            notice: StoredNotice(
                id: 1121959,
                title: "공지 제목",
                contentURL: URL(string: "https://example.com/notice/1121959"),
                isSummarizable: true,
                department: "학사관리과",
                uploadDate: "2026-05-12",
                imageURL: "https://example.com/image.png",
                topicId: 1
            ),
            memo: "저장한 메모",
            alarmDate: alarmDate
        )
    }
}
