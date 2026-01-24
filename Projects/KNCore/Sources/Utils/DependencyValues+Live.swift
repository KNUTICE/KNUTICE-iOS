//
//  DependencyValues+Live.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/9/25.
//

import ComposableArchitecture
import Foundation

extension DependencyValues {    
    var fetchTopicSubscriptionUseCase: FetchTopicSubscriptionsUseCase {
        get { self[FetchTopicSubscriptionUseCaseKey.self] }
        set { self[FetchTopicSubscriptionUseCaseKey.self] = newValue }
    }
    
    var updateTopicSubscriptionUseCase: UpdateTopicSubscriptionUseCase {
        get { self[UpdateTopicSubscriptionUseCaseKey.self] }
        set { self[UpdateTopicSubscriptionUseCaseKey.self] = newValue }
    }
    
    var deleteBookmarkUseCase: DeleteBookmarkUseCase {
        get { self[DeleteBookmarkUseCaseKey.self] }
        set { self[DeleteBookmarkUseCaseKey.self] = newValue }
    }
    
    var saveBookmarkUseCase: SaveBookmarkUseCase {
        get { self[SaveBookmarkUseCaseKey.self] }
        set { self[SaveBookmarkUseCaseKey.self] = newValue }
    }
    
    var updateBookmarkUseCase: UpdateBookmarkUseCase {
        get { self[UpdateBookmarkUseCaseKey.self] }
        set { self[UpdateBookmarkUseCaseKey.self] = newValue }
    }
    
    var fetchBookmarkUseCase: FetchBookmarksUseCase {
        get { self[FetchBookmarkUseCaseKey.self] }
        set { self[FetchBookmarkUseCaseKey.self] = newValue }
    }
}

fileprivate enum FetchTopicSubscriptionUseCaseKey: DependencyKey {
    static let liveValue: FetchTopicSubscriptionsUseCase = FetchTopicSubscriptionsUseCaseImpl()
}

fileprivate enum UpdateTopicSubscriptionUseCaseKey: DependencyKey {
    static let liveValue: UpdateTopicSubscriptionUseCase = UpdateTopicSubscriptionUseCaseImpl()
}

fileprivate enum DeleteBookmarkUseCaseKey: DependencyKey {
    static let liveValue: DeleteBookmarkUseCase = DeleteBookmarkUseCaseImpl()
}

fileprivate enum SaveBookmarkUseCaseKey: DependencyKey {
    static let liveValue: SaveBookmarkUseCase = SaveBookmarkUseCaseImpl()
}

fileprivate enum UpdateBookmarkUseCaseKey: DependencyKey {
    static let liveValue: UpdateBookmarkUseCase = UpdateBookmarkUseCaseImpl()
}

fileprivate enum FetchBookmarkUseCaseKey: DependencyKey {
    static let liveValue: FetchBookmarksUseCase = FetchBookmarksUseCaseImpl()
}
