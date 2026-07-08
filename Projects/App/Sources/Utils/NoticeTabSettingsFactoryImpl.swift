//
//  NoticeTabSettingsFactoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/27/26.
//

import Factory
import KNNotice
import RxRelay

struct NoticeTabSettingsFactoryImpl: NoticeTabSettingsFactory {
    func make(categoriesRelay: BehaviorRelay<[CategoryItem]>) -> NoticeTabSettings? {
        NoticeTabSettings(
            noticeTabItems: NoticeTabItems(categoriesRelay)
        )
    }
}
