//
//  NoticeEntity+CoreDataProperties.swift
//  
//
//  Created by 이정훈 on 1/26/26.
//
//

public import Foundation
public import CoreData


public typealias NoticeEntityCoreDataPropertiesSet = NSSet

extension NoticeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoticeEntity> {
        return NSFetchRequest<NoticeEntity>(entityName: "NoticeEntity")
    }

    @NSManaged public var category: String?
    @NSManaged public var contentUrl: String?
    @NSManaged public var department: String?
    @NSManaged public var id: Int64
    @NSManaged public var imageUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var uploadDate: String?
    @NSManaged public var associatedBookmark: BookmarkEntity?

}
