//
//  DependencyValues+Live.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/9/25.
//

import ComposableArchitecture
import Factory
import Foundation
import KNDomain

extension DependencyValues {        
    public var deleteBookmarkUseCase: DeleteBookmarkUseCase {
        get { self[DeleteBookmarkUseCaseKey.self] }
        set { self[DeleteBookmarkUseCaseKey.self] = newValue }
    }
    
    public var saveBookmarkUseCase: SaveBookmarkUseCase {
        get { self[SaveBookmarkUseCaseKey.self] }
        set { self[SaveBookmarkUseCaseKey.self] = newValue }
    }
    
    public var updateBookmarkUseCase: UpdateBookmarkUseCase {
        get { self[UpdateBookmarkUseCaseKey.self] }
        set { self[UpdateBookmarkUseCaseKey.self] = newValue }
    }
    
    public var fetchBookmarkUseCase: FetchBookmarksUseCase {
        get { self[FetchBookmarksUseCaseKey.self] }
        set { self[FetchBookmarksUseCaseKey.self] = newValue }
    }
}

enum DeleteBookmarkUseCaseKey: DependencyKey {
    public static var liveValue: DeleteBookmarkUseCase {
        fatalError("Must override from App")
    }
}

enum SaveBookmarkUseCaseKey: DependencyKey {
    public static var liveValue: SaveBookmarkUseCase {
        fatalError("Must override from App")
    }
}

enum UpdateBookmarkUseCaseKey: DependencyKey {
    static var liveValue: UpdateBookmarkUseCase {
        fatalError("Must override from App")
    }
}

enum FetchBookmarksUseCaseKey: DependencyKey {
    static var liveValue: FetchBookmarksUseCase {
        fatalError("Must override from App")
    }
}
