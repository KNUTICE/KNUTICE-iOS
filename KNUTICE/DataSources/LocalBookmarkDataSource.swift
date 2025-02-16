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
    func readDTO() -> AnyPublisher<[BookmarkDTO], any Error>
    func isDuplication(id: Int) -> AnyPublisher<Bool, any Error>
    func delete(id: Int) -> AnyPublisher<Void, any Error>
    func update(bookmark: Bookmark) -> AnyPublisher<Void, any Error>
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
        
        noticeEntity.id = Int64(bookmark.notice.id)
        noticeEntity.title = bookmark.notice.title
        noticeEntity.department = bookmark.notice.department
        noticeEntity.uploadDate = bookmark.notice.uploadDate
        noticeEntity.contentUrl = bookmark.notice.contentUrl
        noticeEntity.imageUrl = bookmark.notice.imageUrl
        noticeEntity.category = bookmark.notice.noticeCategory?.rawValue
        
        bookmarkEntity.bookmarkedNotice = noticeEntity
        
        return Future { [weak self] promise in
            self?.backgroundContext.perform {
                do {
                    try self?.backgroundContext.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func readDTO() -> AnyPublisher<[BookmarkDTO], any Error> {
        return readEntities()
            .map { entities in
                entities.map {
                    BookmarkDTO(notice: $0.bookmarkedNotice, details: $0.memo, alarmDate: $0.alarmDate)
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func readEntities() -> AnyPublisher<[BookmarkEntity], any Error> {
        return Future { [weak self] promise in
            self?.backgroundContext.perform {
                let fetchRequest = NSFetchRequest<BookmarkEntity>(entityName: "BookmarkEntity")
                
                do {
                    let bookmarkEntities = try self?.backgroundContext.fetch(fetchRequest)
                    promise(.success(bookmarkEntities ?? []))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func isDuplication(id: Int) -> AnyPublisher<Bool, any Error> {
        return readDTO()
            .flatMap { dto -> AnyPublisher<Bool, any Error> in
                let duplicationCount = dto.filter { $0.notice?.id == Int64(id) }.count
                
                if duplicationCount > 0 {
                    //중복 id가 존재하는 경우
                    return Just(true)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                //중복 id가 존재하지 않는 경우
                return Just(false)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func delete(id: Int) -> AnyPublisher<Void, any Error> {
        return readEntities()
            .flatMap { entities -> AnyPublisher<Void, any Error> in
                return Future { [weak self] promise in
                    self?.backgroundContext.perform {
                        do {
                            //일치하는 id 필터링 후 삭제
                            let filteredEntities = entities.filter { $0.bookmarkedNotice?.id == Int64(id) }
                            filteredEntities.forEach {
                                self?.backgroundContext.delete($0)
                            }
                            
                            //영구 저장소에 반영
                            try self?.backgroundContext.save()
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
        return readEntities()
            .flatMap { entities -> AnyPublisher<Void, any Error> in
                return Future { [weak self] promise in
                    self?.backgroundContext.perform {
                        do {
                            let filteredEntities = entities.filter { $0.bookmarkedNotice?.id == Int64(bookmark.notice.id) }
                            filteredEntities.forEach {
                                $0.memo = bookmark.memo
                                $0.alarmDate = bookmark.alarmDate
                            }
                            
                            try self?.backgroundContext.save()
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
