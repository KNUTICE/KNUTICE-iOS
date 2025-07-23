//
//  BookmarkSectionModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/27/25.
//

import RxDataSources

struct BookmarkSectionModel {
    var items: [Item]
    var identity: Int {
        items[0].notice.id
    }
}

extension BookmarkSectionModel: AnimatableSectionModelType {
    typealias Item = Bookmark
    typealias Identity = Int
    
    init(original: BookmarkSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
