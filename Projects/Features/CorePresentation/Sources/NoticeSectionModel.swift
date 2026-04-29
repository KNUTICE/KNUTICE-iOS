//
//  NoticeSectionModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/14/25.
//

import KNDomain
import RxDataSources

public struct NoticeSectionModel {
    public var items: [Item]
    
    public init(items: [Notice]) {
        self.items = items
    }
}

extension NoticeSectionModel: SectionModelType {
    public typealias Item = Notice
    
    public init(original: NoticeSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
