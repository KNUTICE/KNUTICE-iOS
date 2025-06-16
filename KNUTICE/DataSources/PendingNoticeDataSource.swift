//
//  PendingNoticeDataSource.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/15/25.
//

import CoreData
import Foundation

final class PendingNoticeDataSource {
    static let shared = PendingNoticeDataSource()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let storeURL = URL.storeURL(for: "group.com.fx.KNUTICE", name: "PendingNotice")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: "PendingNotice")
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    private init() {}
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        persistentContainer.newBackgroundContext()
    }()
    
    /// Asynchronously saves a `PendingNoticeEntity` with the given ID to Core Data.
    ///
    /// This method uses `NSManagedObjectContext.perform` to safely execute the save
    /// operation on the background context. If any error occurs during the save process,
    /// it will be thrown to the caller.
    ///
    /// - Parameter id: The unique identifier of the notice to be saved.
    /// - Throws: An error if the save operation fails.
    func save(id: Int) async throws {
        try await backgroundContext.perform {
            let pendingNoticeEntity = PendingNoticeEntity(context: self.backgroundContext)
            pendingNoticeEntity.id = Int64(id)
            
            if self.backgroundContext.hasChanges {
                try self.backgroundContext.save()
            }
        }
    }
    
    /// Asynchronously fetches all `PendingNoticeEntity` objects from Core Data and returns their IDs.
    ///
    /// This method performs a fetch request on the background context to retrieve
    /// all instances of `PendingNoticeEntity`. It maps the `id` values of the fetched
    /// entities to an array of `Int`.
    ///
    /// - Returns: An array of `Int` values representing the IDs of all pending notices.
    /// - Throws: An error if the fetch request fails.
    func fetchAll() async throws -> [Int] {
        return try await backgroundContext.perform {
            let fetchRequest = NSFetchRequest<PendingNoticeEntity>(entityName: "PendingNoticeEntity")
            let entities = try self.backgroundContext.fetch(fetchRequest)
            
            return entities.map {
                Int($0.id)
            }
        }
    }
    
    /// Asynchronously fetches all `PendingNoticeEntity` objects with the specified ID from Core Data.
    ///
    /// This method executes a fetch request on the background context using a predicate
    /// that matches the provided ID. It returns all matching entities, or an empty array if none are found.
    ///
    /// - Parameter id: The unique identifier used to filter the fetch request.
    /// - Returns: An array of `PendingNoticeEntity` objects matching the given ID.
    /// - Throws: An error if the fetch request fails.
    private func fetch(withId id: Int) async throws -> [PendingNoticeEntity] {
        return try await backgroundContext.perform {
            let fetchRequest = NSFetchRequest<PendingNoticeEntity>(entityName: "PendingNoticeEntity")
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            
            return try self.backgroundContext.fetch(fetchRequest)
        }
    }
    
    /// Asynchronously deletes all `PendingNoticeEntity` objects with the specified ID from Core Data.
    ///
    /// This method performs a fetch request on the background context to find entities
    /// matching the provided ID. If any matching entities are found, they are deleted,
    /// and the changes are saved back to the persistent store.
    ///
    /// - Parameter id: The unique identifier of the notice entities to delete.
    /// - Throws: An error if the fetch or save operation fails.
    func delete(withId id: Int) async throws {
        let entities = try await fetch(withId: id)
        
        try await backgroundContext.perform {
            for entity in entities {
                self.backgroundContext.delete(entity)
            }

            if self.backgroundContext.hasChanges {
                try self.backgroundContext.save()
            }
        }
    }
}

fileprivate extension URL {
    static func storeURL(for appGroup: String, name modelName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }
        
        return fileContainer.appendingPathComponent("\(modelName).sqlite")
    }
}
