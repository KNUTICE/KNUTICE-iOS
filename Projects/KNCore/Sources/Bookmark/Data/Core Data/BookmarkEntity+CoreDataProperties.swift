//
//  BookmarkEntity+CoreDataProperties.swift
//  
//
//  Created by 이정훈 on 1/26/26.
//
//

public import Foundation
public import CoreData


public typealias BookmarkEntityCoreDataPropertiesSet = NSSet

extension BookmarkEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkEntity> {
        return NSFetchRequest<BookmarkEntity>(entityName: "BookmarkEntity")
    }

    @NSManaged public var alarmDate: Date?
    @NSManaged public var createdAt: Date?
    @NSManaged public var memo: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var bookmarkedNotice: NoticeEntity?

}
