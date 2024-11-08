//
//  GeneralNoticeRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift

protocol NoticeRepository {
    func fetchNotices() -> Single<[Notice]>
    func fetchNotices(after number: Int) -> Single<[Notice]>
}
