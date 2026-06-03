//
//  NoticeTabSettingsFactory.swift
//  KNNotice
//
//  Created by 이정훈 on 5/27/26.
//

import RxRelay

@MainActor
public protocol NoticeTabSettingsFactory {
    func make(categoriesRelay: BehaviorRelay<[CategoryItem]>) -> NoticeTabSettings?
}
