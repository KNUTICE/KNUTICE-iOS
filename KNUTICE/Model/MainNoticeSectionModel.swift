//
//  MainNoticeSectionModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/11/24.
//

import RxDataSources

struct MainNoticeSectionModel {
    var header: String
    var items: [Item]
}

extension MainNoticeSectionModel: SectionModelType {
    typealias Item = MainNotice
    
    init(original: MainNoticeSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
