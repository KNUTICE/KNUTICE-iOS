//
//  LocalBookmarkDataSource.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/10/25.
//

import Combine
import CoreData

protocol LocalBookmarkDataSource {
    /// Saves a single `Bookmark` to Core Data.
    ///
    /// - Parameter bookmark: The `Bookmark` domain model to persist.
    /// - Returns: An `AnyPublisher<Void, Error>` that completes on success or publishes an error if the save fails.
    ///
    /// - Note:
    ///   * A new `BookmarkEntity` and its associated `NoticeEntity` are inserted into a
    ///     background `NSManagedObjectContext`.
    ///   * `createdAt` is set to the current date.
    ///   * The context is saved only if it has pending changes.
    ///   * All work is performed on the context’s queue via `perform`.
    func save(_ bookmark: Bookmark) -> AnyPublisher<Void, any Error>
    
    /// Fetches bookmarks with pagination.
    ///
    /// - Parameters:
    ///   - page: The page number starting from 0.
    ///   - pageSize: The maximum number of items to fetch per page. Default is 20.
    ///   - option: The sorting option for the results. Default is `.createdAtDescending`.
    ///
    /// - Returns: An `AnyPublisher<[BookmarkDTO], Error>` that emits an array of `BookmarkDTO` or an error.
    ///
    /// - Note:
    ///   Internally, this method calls `readBookmarkEntities(page:fetchLimit:)` to retrieve
    ///   `BookmarkEntity` objects, then maps them to `BookmarkDTO` using `createBookmarkDTOs(from:)`.
    func fetch(page: Int, pageSize: Int, sortBy option: BookmarkSortOption) -> AnyPublisher<[BookmarkDTO], any Error>
    
    /// Checks whether a `NoticeEntity` with the given ID already exists in Core Data.
    ///
    /// - Parameter id: The unique identifier of the notice to check for duplication.
    /// - Returns: An `AnyPublisher<Bool, Error>` that emits `true` if a duplicate exists, otherwise `false`.
    ///
    /// - Note:
    ///   This method fetches `NoticeEntity` objects matching the given ID using `fetchNoticeEntities(withId:)`.
    ///   If at least one entity is found, it is considered a duplicate.
    func isDuplication(id: Int) -> AnyPublisher<Bool, any Error>
    
    /// Fetches bookmark items where either `createdAt` or `updatedAt` is `nil`.
    ///
    /// This method asynchronously fetches `BookmarkEntity` objects from the background context
    /// where either `createdAt` or `updatedAt` is `nil`. The result is then mapped to an array of
    /// `BookmarkDTO` and returned as a Combine publisher.
    ///
    /// - Returns: An `AnyPublisher` that emits an array of `BookmarkDTO` on success,
    ///            or an `Error` if the fetch fails.
    ///
    /// - Note: This operation is performed on a background context using `NSManagedObjectContext.perform`.
    func fetchItemsWhereTimestampsAreNil() -> AnyPublisher<[BookmarkDTO], any Error>
    
    /// Deletes all `NoticeEntity` objects that match the given ID from Core Data.
    ///
    /// - Parameter id: The identifier of the notice whose associated bookmark(s) should be deleted.
    /// - Returns: An `AnyPublisher<Void, Error>` that completes on success or publishes an error if the deletion fails.
    ///
    /// - Note:
    ///   This method first fetches `NoticeEntity` instances using `fetchNoticeEntities(withId:)`.
    ///   Then, each matching entity is deleted from the background context.
    ///   The context is saved if there are any changes, ensuring the deletion is persisted.
    func delete(id: Int) -> AnyPublisher<Void, any Error>
    
    /// Updates an existing bookmark's memo and alarm date in Core Data.
    ///
    /// - Parameter bookmark: The `Bookmark` model containing updated memo and alarm date values.
    /// - Returns: An `AnyPublisher<Void, Error>` that completes on success or publishes an error if the update fails.
    ///
    /// - Note:
    ///   This method fetches `BookmarkEntity` instances associated with the given notice ID using `fetchBookmarkEntities(withId:)`.
    ///   It updates the `memo` and `alarmDate` fields of each matching entity, then saves the changes to the background context.
    func update(bookmark: Bookmark) -> AnyPublisher<Void, any Error>
    
    /// Updates the `createdAt` and `updatedAt` timestamps for the given bookmarks in Core Data.
    ///
    /// This method takes an array of `BookmarkUpdate` objects, each containing a `Bookmark` and its
    /// corresponding `createdAt` and `updatedAt` timestamps. It performs the following steps:
    /// 1. Fetches the corresponding `BookmarkEntity` instances from Core Data based on the bookmark ID.
    /// 2. Applies the new timestamps using the background context.
    /// 3. Collects all update operations and saves the context once after all updates are complete.
    ///
    /// - Parameter updates: An array of `BookmarkUpdate` values representing the bookmarks to update
    ///                      along with their respective timestamps.
    /// - Returns: A Combine `AnyPublisher` that emits `Void` on success or an `Error` if any step fails.
    ///
    /// - Note:
    ///   - The updates are executed on a background context asynchronously using `NSManagedObjectContext.perform`.
    ///   - The final context save is performed synchronously with `performAndWait` to ensure consistency.
    func update(_ updates: [BookmarkUpdate]) -> AnyPublisher<Void, any Error>
}

extension LocalBookmarkDataSource {
    func fetch(
        page: Int, pageSize: Int = 20,
        sortBy option: BookmarkSortOption
    ) -> AnyPublisher<[BookmarkDTO], any Error> {
        return self.fetch(page: page, pageSize: pageSize, sortBy: option)
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
}

//MARK: - Save Methods
extension LocalBookmarkDataSourceImpl {
    func save(_ bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return Future { [unowned self] promise in
            self.backgroundContext.perform {
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
                
                do {
                    if self.backgroundContext.hasChanges {
                        try self.backgroundContext.save()
                    }
                    
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

//MARK: - Fetch Methods
extension LocalBookmarkDataSourceImpl {
    func fetch(
        page: Int,
        pageSize: Int = 20,
        sortBy option: BookmarkSortOption = .createdAtDescending
    ) -> AnyPublisher<[BookmarkDTO], any Error> {
        return readBookmarkEntities(page: page, fetchLimit: pageSize, sortBy: option)
            .map { [unowned self] entities in
                return self.createBookmarkDTOs(from: entities)
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
    
    func fetchItemsWhereTimestampsAreNil() -> AnyPublisher<[BookmarkDTO], any Error> {
        return Future { [unowned self] promise in
            self.backgroundContext.perform {
                let request = NSFetchRequest<BookmarkEntity>(entityName: "BookmarkEntity")
                request.predicate = NSPredicate(format: "createdAt == nil OR updatedAt == nil")
                
                do {
                    let entities = try self.backgroundContext.fetch(request)
                    
                    promise(.success(entities))
                } catch {
                    promise(.failure(error))
                }
                
            }
        }
        .map { [unowned self] (entities: [BookmarkEntity]) in
            self.createBookmarkDTOs(from: entities)
        }
        .eraseToAnyPublisher()
    }
    
    private func readBookmarkEntities(
        page: Int,
        fetchLimit: Int = 20,
        sortBy option: BookmarkSortOption = .createdAtDescending
    ) -> AnyPublisher<[BookmarkEntity], any Error> {
        return Future { [unowned self] promise in
            self.backgroundContext.perform {
                let fetchRequest = NSFetchRequest<BookmarkEntity>(entityName: "BookmarkEntity")
                fetchRequest.fetchLimit = fetchLimit
                fetchRequest.fetchOffset = page * fetchLimit
                fetchRequest.sortDescriptors = [option.descriptor]
                
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
                let request = NSFetchRequest<BookmarkEntity>(entityName: "BookmarkEntity")
                request.predicate = NSPredicate(format: "bookmarkedNotice.id == %d", id)
                
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
    
    private func createBookmarkDTOs(from entities: [BookmarkEntity]) -> [BookmarkDTO] {
        entities.map {
            return BookmarkDTO(
                notice: $0.bookmarkedNotice,
                details: $0.memo,
                alarmDate: $0.alarmDate
            )
        }
    }
}

//MARK: - Delete Methos
extension LocalBookmarkDataSourceImpl {
    func delete(id: Int) -> AnyPublisher<Void, any Error> {
        return fetchNoticeEntities(withId: id)
            .flatMap { entities -> AnyPublisher<Void, any Error> in
                return Future { [unowned self] promise in
                    self.backgroundContext.perform {
                        //id에 해당하는 북마크 데이터 삭제
                        entities.forEach {
                            self.backgroundContext.delete($0)
                        }
                        
                        do {
                            if self.backgroundContext.hasChanges {
                                try self.backgroundContext.save()    //영구 저장소에 반영
                            }
                            
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
}

//MARK: - Update Methods
extension LocalBookmarkDataSourceImpl {
    func update(bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return fetchBookmarkEntities(withId: bookmark.notice.id)
            .flatMap { entities -> AnyPublisher<Void, any Error> in
                return Future { [unowned self] promise in
                    self.backgroundContext.perform {
                        entities.forEach {
                            $0.memo = bookmark.memo
                            $0.alarmDate = bookmark.alarmDate
                            $0.updatedAt = Date()
                        }
                        
                        do {
                            if self.backgroundContext.hasChanges {
                                try self.backgroundContext.save()
                            }
                            
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
    
    func update(_ updates: [BookmarkUpdate]) -> AnyPublisher<Void, any Error> {
        var publishers = [AnyPublisher<Void, any Error>]()
        
        for update in updates {
            let publisher = fetchBookmarkEntities(withId: update.bookmark.notice.id)
                .map { [weak self] entities in
                    self?.backgroundContext.performAndWait {
                        entities.forEach {
                            $0.createdAt = update.createdAt
                            $0.updatedAt = update.updatedAt
                        }
                    }
                    
                    return
                }
                .eraseToAnyPublisher()
            
            publishers.append(publisher)
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .tryMap { [weak self] _ in
                try self?.backgroundContext.performAndWait {
                    if self?.backgroundContext.hasChanges == true {
                        try self?.backgroundContext.save()
                    }
                }
                
                return
            }
            .eraseToAnyPublisher()
    }
}

fileprivate extension BookmarkSortOption {
    var descriptor: NSSortDescriptor {
        switch self {
        case .createdAtAscending:
            return NSSortDescriptor(key: "createdAt", ascending: true)
        case .createdAtDescending:
            return NSSortDescriptor(key: "createdAt", ascending: false)
        }
    }
}
