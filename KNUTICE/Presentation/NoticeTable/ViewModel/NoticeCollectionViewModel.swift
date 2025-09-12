//
//  NoticeCollectionViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/14/25.
//

import Combine
import Factory
import Foundation
import KNUTICECore
import os
import RxRelay

final class NoticeCollectionViewModel: NoticeSectionModelProvidable, NoticeFetchable {
    /// View와 바인딩할 데이터
    /// 서버에서 가져온 데이터를 해당 변수에 저장
    let notices: BehaviorRelay<[NoticeSectionModel]> = BehaviorRelay(value: [])
    /// 공지사항 데이터 요청을 위한 `NoticeRepository` 인스턴스
    @Injected(\.noticeRepository) private var repository
    /// 서버와 통신 중임을 나타내는 변수
    let isFetching: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    /// 새로고침 여부를 나타내는 변수
    let isRefreshing: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    /// 공지 카테고리를 나타내는 프로퍼티로, 공지의 종류를 구분하는 데 사용
    private let category: NoticeCategory
    /// Publisher 구독 메모리 관리를 위한 cancellable bag
    private var cancellables: Set<AnyCancellable> = []
    /// 콘솔 메시지 로깅을 위한 인스턴스
    private var logger: Logger = Logger()
    
    init(category: NoticeCategory) {
        self.category = category
    }
    
    /// 서버에 `category`에 대한 공지사항 데이터 요청하고,
    /// 전달 받은 데이터는 `notices`에 업데이트
    func fetchNotices(isRefreshing: Bool = false) {
        if isRefreshing {
            self.isRefreshing.accept(true)
        } else {
            self.isFetching.accept(true)
        }
        
        repository.fetchNotices(for: category.rawValue)
            .map {
                NoticeSectionModel(items: $0)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if isRefreshing {
                    self?.isRefreshing.accept(false)
                } else {
                    self?.isFetching.accept(false)
                }
                
                switch completion {
                case .finished:
                    self?.logger.info("Successfully fetched Notices")
                case .failure(let error):
                    self?.logger.error("NoticeCollectionViewModel.fetchNotices() error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] in
                self?.notices.accept([$0])
            })
            .store(in: &cancellables)
    }
    
    /// 무한 스크롤 구현을 위해 다음 페이지 공지사항 요청하고,
    /// 전달 받은 데이터는 `notices`에 추가 후 업데이트
    func fetchNextPage() {
        guard let lastNumber = notices.value.first?.items.last?.id else {
            return
        }
        
        isFetching.accept(true)
        repository.fetchNotices(for: category.rawValue, after: lastNumber)
            .map {
                NoticeSectionModel(items: $0)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isFetching.accept(false)
                
                switch completion {
                case .finished:
                    self?.logger.info( "Successfully fetched next page")
                case .failure(let error):
                    self?.logger.error("NoticeCollectionViewModel.fetchNextPage() error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] in
                var currentValues = self?.notices.value.first
                currentValues?.items.append(contentsOf: $0.items)
                
                guard let currentValues else { return }
                
                self?.notices.accept([currentValues])
            })
            .store(in: &cancellables)
    }
}
