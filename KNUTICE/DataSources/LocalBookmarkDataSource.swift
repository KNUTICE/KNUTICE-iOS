//
//  LocalBookmarkDataSource.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import Combine
import CoreData

protocol LocalBookmarkDataSource {
    func save(_ bookmark: Bookmark) -> AnyPublisher<Void, any Error>
    func read() -> AnyPublisher<[BookmarkDTO], any Error>
}

final class LocalBookmarkDataSourceImpl: LocalBookmarkDataSource {
    static let shared = LocalBookmarkDataSourceImpl()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Bookmark")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        persistentContainer.newBackgroundContext()
    }()
    
    func save(_ bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        let bookmarkEntity = BookmarkEntity(context: backgroundContext)
        let noticeEntity = NoticeEntity(context: backgroundContext)
        
        bookmarkEntity.details = bookmark.details
        bookmarkEntity.alarmDate = bookmark.alarmDate
        
        noticeEntity.id = Int64(bookmark.notice.id)
        noticeEntity.title = bookmark.notice.title
        noticeEntity.department = bookmark.notice.department
        noticeEntity.uploadDate = bookmark.notice.uploadDate
        noticeEntity.contentUrl = bookmark.notice.uploadDate
        noticeEntity.imageUrl = bookmark.notice.imageUrl
        
        bookmarkEntity.bookmarkedNotice = noticeEntity
//        noticeEntity.associatedBookmark = bookmarkEntity
        
        return Future { promise in
            self.backgroundContext.perform {
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
    
    func read() -> AnyPublisher<[BookmarkDTO], any Error> {
        return Future { promise in
            self.backgroundContext.perform {
                let fetchRequest = NSFetchRequest<BookmarkEntity>(entityName: "BookmarkEntity")
                fetchRequest.relationshipKeyPathsForPrefetching = ["bookmaredNotice"]
                
                do {
                    let bookmarkEntities = try self.backgroundContext.fetch(fetchRequest)
                    promise(.success(bookmarkEntities.map {
                        BookmarkDTO(notice: $0.bookmarkedNotice, details: $0.details, alarmDate: $0.alarmDate)
                    }))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
