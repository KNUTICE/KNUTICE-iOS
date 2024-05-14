//
//  MainViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/11/24.
//

import RxCocoa
import RxSwift
import RxRelay
import RxDataSources

final class MainViewModel {
    var notices = BehaviorRelay<[SectionOfNotice]>(value: [])
    
    init() {
        self.fetchNotices()
    }
    
    func getCellData() -> Observable<[SectionOfNotice]> {
        return notices.asObservable()
    }
    
    func fetchNotices() {
        notices.accept([SectionOfNotice(header: "일반소식",
                                        items: Notice.generalNoticesSampleData),
                        SectionOfNotice(header: "학사공지",
                                        items: Notice.academicNoticesSampleData),
                        SectionOfNotice(header: "장학안내",
                                        items: Notice.scholarshipNoticesSampleData),
                        SectionOfNotice(header: "행사안내",
                                        items: Notice.eventNoticesSampleData)])
    }
}
