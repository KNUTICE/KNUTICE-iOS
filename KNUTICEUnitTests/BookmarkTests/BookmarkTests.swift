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
    
    func test_bookmarkCRUD_returnsExpectedCount() {
        //Given
        let expectation = XCTestExpectation(description: "CRUD bookmark data")
        
        //When
        dataSource.saveDummyData()    //Saves 1,000 dummy records into the database.
            .flatMap { _ in
                return self.dataSource.fetch(page: 0)    //Fetches 20 items using pagination.
            }
            .flatMap { bookmarks in
                XCTAssertEqual(bookmarks.count, 20)
                
                var publishers = [AnyPublisher<Void, Error>]()
                
                //Delete all stored data
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
            }, receiveValue: { _ in
                //Nothing to do
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
}

extension LocalBookmarkDataSourceImpl {
    func saveDummyData() -> AnyPublisher<Void, any Error> {
        return Future { promise in
            self.backgroundContext.perform {
                (1...1_000).forEach {
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
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
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
