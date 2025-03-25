//
//  MainNoticeRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import RxSwift
import Combine

protocol MainNoticeRepository {
    @available(*, deprecated, message: "fetch() 메서드 대체 사용")
    func fetchMainNotices() -> Observable<[SectionOfNotice]>
    func fetch() -> AnyPublisher<[SectionOfNotice], any Error>
    func fetchTempData() -> AnyPublisher<[SectionOfNotice], any Error>
}
