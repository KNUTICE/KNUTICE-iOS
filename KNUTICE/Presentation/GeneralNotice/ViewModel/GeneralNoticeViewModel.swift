//
//  GeneralNoticeViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/15/24.
//

import Foundation
import RxCocoa
import RxSwift

final class GeneralNoticeViewModel {
    var notices = BehaviorRelay<[SectionOfNotice]>(value: [])
    
    init() {
        fetchNotices()
    }
}

extension GeneralNoticeViewModel: ViewModel {
    func fetchNotices() {
        notices.accept([
            SectionOfNotice(header: "헤더", items: Notice.generalNoticesSampleData)
        ])
    }
    
    func getCellData() -> Observable<[SectionOfNotice]> {
        return notices.asObservable()
    }
}

