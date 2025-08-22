//
//  NoticeManager.swift
//  KNUTICEWidgetExtension
//
//  Created by 이정훈 on 8/5/25.
//

import Factory
import Foundation
import KNUTICECore

struct NoticeManager {
    @Injected(\.noticeRepository) private var repository
    
    static let shared: NoticeManager = .init()
    
    private init() {}
    
    func fetchNotices(limit size: Int, category: NoticeCategory) async -> [Notice] {
        do {
            let notices = try await repository.fetchNotices(for: category, size: size)
            
            return notices
        } catch {
            return []
        }
    }
}
