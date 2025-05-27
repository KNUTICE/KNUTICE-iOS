//
//  BookmarkSectionModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/27/25.
//

import RxDataSources

struct BookmarkSectionModel {
    var items: [Item]
}

extension BookmarkSectionModel: SectionModelType {
    typealias Item = Bookmark
    
    init(original: BookmarkSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
