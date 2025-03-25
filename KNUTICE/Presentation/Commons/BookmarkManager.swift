//
//  BookmarkManager.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/14/25.
//

import Factory
import Foundation

class BookmarkManager {
    @Injected(\.bookmarkRepository) var repository: BookmarkRepository
    @Injected(\.bookmarkService) var service: BookmarkService
}
