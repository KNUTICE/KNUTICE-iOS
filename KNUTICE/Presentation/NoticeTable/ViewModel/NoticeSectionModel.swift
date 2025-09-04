//
//  NoticeSectionModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/14/25.
//

import KNUTICECore
import RxDataSources

struct NoticeSectionModel {
    var items: [Item]
}

extension NoticeSectionModel: SectionModelType {
    typealias Item = Notice
    
    init(original: NoticeSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
