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
    func fetch(page: Int, pageSize: Int) -> AnyPublisher<[BookmarkDTO], any Error>
    func isDuplication(id: Int) -> AnyPublisher<Bool, any Error>
    func delete(id: Int) -> AnyPublisher<Void, any Error>
    func update(bookmark: Bookmark) -> AnyPublisher<Void, any Error>
}

extension LocalBookmarkDataSource {
    func fetch(page: Int, pageSize: Int = 20) -> AnyPublisher<[BookmarkDTO], any Error> {
        return self.fetch(page: page, pageSize: pageSize)
    }
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
        
        return Future { [unowned self] promise in
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
    
    func fetch(page: Int, pageSize: Int = 20) -> AnyPublisher<[BookmarkDTO], any Error> {
        return readBookmarkEntities(page: page, fetchLimit: pageSize)
            .map { entities in
                entities.map {
                    BookmarkDTO(
                        notice: $0.bookmarkedNotice,
                        details: $0.memo,
                        alarmDate: $0.alarmDate,
                        createdAt: $0.createdAt ?? $0.bookmarkedNotice?.uploadDate?.toDate() ?? Date()
                    )
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func readBookmarkEntities(page: Int, fetchLimit: Int = 20) -> AnyPublisher<[BookmarkEntity], any Error> {
        return Future { [unowned self] promise in
            self.backgroundContext.perform {
                let fetchRequest = NSFetchRequest<BookmarkEntity>(entityName: "BookmarkEntity")
                fetchRequest.fetchLimit = fetchLimit
                fetchRequest.fetchOffset = page * fetchLimit
//                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
                
                do {
                    let bookmarkEntities = try self.backgroundContext.fetch(fetchRequest)
                    promise(.success(bookmarkEntities))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func isDuplication(id: Int) -> AnyPublisher<Bool, any Error> {
        return fetchNoticeEntities(withId: id)
            .flatMap { entities -> AnyPublisher<Bool, any Error> in
                return Just(!entities.isEmpty)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func delete(id: Int) -> AnyPublisher<Void, any Error> {
        return fetchNoticeEntities(withId: id)
            .flatMap { entities -> AnyPublisher<Void, any Error> in
                return Future { [unowned self] promise in
                    self.backgroundContext.perform {
                        do {
                            //id에 해당하는 북마크 데이터 삭제
                            entities.forEach {
                                self.backgroundContext.delete($0)
                            }
                            
                            try self.backgroundContext.save()    //영구 저장소에 반영
                            promise(.success(()))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
    }
    
    func update(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return fetchBookmarkEntities(withId: bookmark.notice.id)
            .flatMap { entities -> AnyPublisher<Void, any Error> in
                return Future { [unowned self] promise in
                    self.backgroundContext.perform {
                        do {
                            entities.forEach {
                                $0.memo = bookmark.memo
                                $0.alarmDate = bookmark.alarmDate
                            }
                            
                            try self.backgroundContext.save()
                            promise(.success(()))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchNoticeEntities(withId id: Int) -> AnyPublisher<[NoticeEntity], any Error> {
        return Future { [unowned self] promise in
            self.backgroundContext.perform {
                let request = NSFetchRequest<NoticeEntity>(entityName: "NoticeEntity")
                request.predicate = NSPredicate(format: "id == %d", id)
                
                do {
                    let entities = try self.backgroundContext.fetch(request)
                    promise(.success(entities))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func fetchBookmarkEntities(withId id: Int) -> AnyPublisher<[BookmarkEntity], any Error> {
        return Future { [unowned self] promise in
            self.backgroundContext.perform {
                do {
                    let request = NSFetchRequest<BookmarkEntity>(entityName: "BookmarkEntity")
                    request.predicate = NSPredicate(format: "bookmarkedNotice.id == %d", id)
                    let entities = try self.backgroundContext.fetch(request)
                    print(entities)
                    promise(.success(entities))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

fileprivate extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        return dateFormatter.date(from: self)
    }
}
