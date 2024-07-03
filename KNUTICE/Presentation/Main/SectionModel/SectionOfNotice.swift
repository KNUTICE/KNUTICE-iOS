//
//  SectionOfNotice.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/11/24.
//

import RxDataSources

struct SectionOfNotice {
    var header: String
    var items: [Item]
}

extension SectionOfNotice: SectionModelType {
    typealias Item = MainNotice
    
    init(original: SectionOfNotice, items: [Item]) {
        self = original
        self.items = items
    }
}
