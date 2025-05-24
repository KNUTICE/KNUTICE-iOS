//
//  LocalNotificationSubscriptionDataSource.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/21/24.
//

import Combine
import CoreData

protocol LocalNotificationSubscriptionDataSource {
    func createDataIfNeeded() throws
    func createData() -> AnyPublisher<Void, any Error>
    func readData() -> AnyPublisher<[String: Bool], any Error>
    func updateData(key: NoticeCategory, value: Bool) -> AnyPublisher<Void, any Error>
}

final class LocalNotificationDataSourceImpl: LocalNotificationSubscriptionDataSource {
    enum DataError: String, Error {
        case noData = "Notification permission data is missing"
    }
    
    private init() {}
    
    static let shared = LocalNotificationDataSourceImpl()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Notification")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        persistentContainer.newBackgroundContext()
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    @available(*, deprecated, message: "Use createData() instead")
    func createDataIfNeeded() throws {
        let notificationPermissions = NotificationPermissions(context: mainContext)
        notificationPermissions.generalNoticeNotification = true
        notificationPermissions.academicNoticeNotification = true
        notificationPermissions.scholarshipNoticeNotification = true
        notificationPermissions.eventNoticeNotification = true
        
        try mainContext.save()
        UserDefaults.standard.set(true, forKey: "isInitializedNotificationSettings")
    }
    
    func createData() -> AnyPublisher<Void, any Error> {
        return Future { promise in
            do {
                let notificationPermissions = NotificationPermissions(context: self.backgroundContext)
                notificationPermissions.generalNoticeNotification = true
                notificationPermissions.academicNoticeNotification = true
                notificationPermissions.scholarshipNoticeNotification = true
                notificationPermissions.eventNoticeNotification = true
                
                try self.backgroundContext.save()
                UserDefaults.standard.set(true, forKey: "isInitializedNotificationSettings")
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func readData() -> AnyPublisher<[String: Bool], any Error> {
        return Future { promise in
            self.backgroundContext.perform {
                do {
                    let request = NotificationPermissions.fetchRequest()
                    let results = try self.backgroundContext.fetch(request)
                    if let result = results.first {
                        let permissions = [
                            "generalNotice": result.generalNoticeNotification,
                            "academicNotice": result.academicNoticeNotification,
                            "scholarshipNotice": result.scholarshipNoticeNotification,
                            "eventNotice": result.eventNoticeNotification,
                            "employmentNotice": result.employmentNoticeNotification
                        ]
                        
                        print(permissions)
                        
                        promise(.success(permissions))
                    } else {
                        promise(.failure(DataError.noData))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateData(key: NoticeCategory, value: Bool) -> AnyPublisher<Void, any Error> {
        return Future { promise in
            self.backgroundContext.perform {
                do {
                    let request = NotificationPermissions.fetchRequest()
                    let results = try self.backgroundContext.fetch(request)
                    
                    switch key {
                    case .generalNotice:
                        results.first?.generalNoticeNotification = value
                    case .academicNotice:
                        results.first?.academicNoticeNotification = value
                    case .scholarshipNotice:
                        results.first?.scholarshipNoticeNotification = value
                    case .eventNotice:
                        results.first?.eventNoticeNotification = value
                    case .employmentNotice:
                        results.first?.employmentNoticeNotification = value
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
}
