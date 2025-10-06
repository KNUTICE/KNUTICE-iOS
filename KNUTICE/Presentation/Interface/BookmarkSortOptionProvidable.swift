//
//  BookmarkSortOptionProvidable.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/5/25.
//

import Foundation

@MainActor
protocol BookmarkSortOptionProvidable: AnyObject {
    var bookmarkSortOption: BookmarkSortOption { get set }
}
