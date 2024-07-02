//
//  GeneralNoticeRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift

protocol GeneralNoticeRepository {
    func fetchNotices() -> Observable<[Notice]>
}
