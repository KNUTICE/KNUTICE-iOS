//
//  GeneralNoticeRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift
import Combine

protocol NoticeRepository {
    @available(*, deprecated)
    func fetchNotices(for category: NoticeCategory) -> Single<[Notice]>
    @available(*, deprecated)
    func fetchNotices(for category: NoticeCategory, after number: Int) -> Single<[Notice]>
    func fetchNotices(for category: NoticeCategory) -> AnyPublisher<[Notice], any Error>
    func fetchNotices(for category: NoticeCategory, after number: Int) -> AnyPublisher<[Notice], any Error>
    func fetchNotices(by nttIds: [Int]) -> AnyPublisher<[Notice], any Error>
    func fetchNotice(by nttId: Int) -> AnyPublisher<Notice?, any Error>
}
