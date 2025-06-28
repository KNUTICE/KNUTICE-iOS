//
//  GeneralNoticeRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift
import Combine

protocol NoticeRepository {
    func fetchNotices(for category: NoticeCategory) -> AnyPublisher<[Notice], any Error>
    func fetchNotices(for category: NoticeCategory, after number: Int) -> AnyPublisher<[Notice], any Error>
    func fetchNotices(by nttIds: [Int]) -> AnyPublisher<[Notice], any Error>
    func fetchNotice(by nttId: Int) -> AnyPublisher<Notice?, any Error>
    func fetchNotice(by nttId: Int) async throws -> Notice?
}
