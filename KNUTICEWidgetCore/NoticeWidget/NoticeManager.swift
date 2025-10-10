//
//  NoticeManager.swift
//  KNUTICEWidgetExtension
//
//  Created by 이정훈 on 8/5/25.
//

import Factory
import Foundation
import KNUTICECore

public actor NoticeManager {
    @Injected(\.noticeRepository) private var repository
    
    public static let shared: NoticeManager = .init()
    
    private init() {}
    
    public func fetchNotices(limit size: Int, category: NoticeCategory) async -> [Notice] {
        do {
            let notices = try await repository.fetchNotices(for: category.rawValue, size: size)
            
            return notices
        } catch {
            return []
        }
    }
}
