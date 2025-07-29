//
//  MainNoticeRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import RxSwift
import Combine

protocol MainNoticeRepository {
    func fetch() -> AnyPublisher<[SectionOfNotice], any Error>
    func fetchTempData() -> AnyPublisher<[SectionOfNotice], any Error>
}
