//
//  BookmarkTests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 6/11/25.
//

import Combine
import Factory
import XCTest
@testable import KNUTICE

final class BookmarkTests: XCTestCase {
    private var dataSource: LocalBookmarkDataSourceImpl!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        dataSource = LocalBookmarkDataSourceImpl.shared
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataSource = nil
        cancellables = nil
    }

    func test_saveLargeNumberOfBookmarks_returnsSuccess() {
        //Given
        let expectation = XCTestExpectation(description: "save 1K dummy bookmark data")
       
        //When
        Task {
            do {
                try await dataSource.saveDummyData()
                expectation.fulfill()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchBookmarks_batchSize20_returnsExpectedCount() {
        //Given
        let expectation = XCTestExpectation(description: "fetch bookmark data with batch size 20")
        
        //When
        dataSource.fetch(page: 0)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: {
                //Then
                XCTAssertEqual($0.count, 20)
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_memoryStorage_returnsExpectedData() {
        self.measure(metrics: [XCTMemoryMetric()]) {
            test_fetchBookmarks_batchSize20_returnsExpectedCount()
        }
    }
    
    func test_fetchAllBookmarks_returnsExpectedCount() {
        //Given
        let expectation = XCTestExpectation(description: "fetch all bookmark data")
        
        //When
        dataSource.fetch(page: 0, pageSize: 0)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: {
                //Then
                XCTAssertEqual($0.count, 10_000)
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_deleteAllBookmarks_retunsSuccess() {
        //Given
        let expectation = XCTestExpectation(description: "delete bookmark data")
        
        dataSource.fetch(page: 0, pageSize: 0)
            .flatMap { bookmarks -> AnyPublisher<[Void], Error> in
                var publishers = [AnyPublisher<Void, Error>]()
                
                for bookmark in bookmarks {
                    guard let notice = bookmark.notice else { continue }
                    publishers.append(self.dataSource.delete(id: Int(notice.id)))
                }
                
                return Publishers.MergeMany(publishers)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: {
                print($0.count)
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }

}

extension LocalBookmarkDataSourceImpl {
    func saveDummyData() async throws {
        try await withCheckedThrowingContinuation { continuation in
            self.backgroundContext.perform {
                (1...10_000).forEach {
                    let bookmark = self.createBookmark(id: $0)
                    let bookmarkEntity = BookmarkEntity(context: self.backgroundContext)
                    let noticeEntity = NoticeEntity(context: self.backgroundContext)
                    
                    bookmarkEntity.memo = bookmark.memo
                    bookmarkEntity.alarmDate = bookmark.alarmDate
                    bookmarkEntity.createdAt = Date()
                    
                    noticeEntity.id = Int64(bookmark.notice.id)
                    noticeEntity.title = bookmark.notice.title
                    noticeEntity.department = bookmark.notice.department
                    noticeEntity.uploadDate = bookmark.notice.uploadDate
                    noticeEntity.contentUrl = bookmark.notice.contentUrl
                    noticeEntity.imageUrl = bookmark.notice.imageUrl
                    noticeEntity.category = bookmark.notice.noticeCategory?.rawValue
                    
                    bookmarkEntity.bookmarkedNotice = noticeEntity
                }
                
                do {
                    try self.backgroundContext.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func createBookmark(id: Int) -> Bookmark {
        Bookmark(
            notice: Notice(
                id: id,
                title: "test",
                contentUrl: "test",
                department: "test",
                uploadDate: "test",
                imageUrl: "test",
                noticeCategory: .generalNotice),
            memo: "",
            alarmDate: Date()
        )
    }
}
