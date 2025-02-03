//
//  BookmarkManager.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/14/25.
//

import Foundation

class BookmarkManager {
    let repository: BookmarkRepository
    
    init(repository: BookmarkRepository) {
        self.repository = repository
    }
}
