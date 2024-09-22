//
//  MainNoticeRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import RxSwift

protocol MainNoticeRepository {
    func fetchMainNotices() -> Observable<[SectionOfNotice]>
}
