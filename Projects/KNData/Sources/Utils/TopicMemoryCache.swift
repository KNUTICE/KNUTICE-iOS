//
//  TopicMemoryCache.swift
//  KNData
//
//  Created by 이정훈 on 7/28/26.
//

import Foundation
import KNDomain

/// An in-memory cache that stores topic categories by topic identifier.
actor TopicMemoryCache {

    /// The shared cache instance used by topic repository logic.
    static let shared: TopicMemoryCache = TopicMemoryCache()

    /// Cached category values keyed by topic identifier.
    private var cache: [Int: any CategoryProtocol] = [:]

    private init() {}

    /// Returns the cached topic for the specified topic identifier.
    func topic(for id: Int) -> (any CategoryProtocol)? {
        cache[id]
    }

    /// Stores the category for the specified topic identifier.
    func store(_ category: any CategoryProtocol, for id: Int) {
        cache[id] = category
    }

    /// Removes all cached topic categories.
    func removeAll() {
        cache.removeAll()
    }
}
