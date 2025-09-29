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
import RxSwift

class NoticeCollectionViewModel<Category>: NoticeSectionModelProvidable, NoticeFetchable where Category: RawRepresentable, Category.RawValue == String {
    /// View와 바인딩할 데이터
    /// 서버에서 가져온 데이터를 해당 변수에 저장
    let notices: BehaviorRelay<[NoticeSectionModel]> = BehaviorRelay(value: [])
    /// 공지사항 데이터 요청을 위한 `NoticeRepository` 인스턴스
    @Injected(\.noticeRepository) private var repository
    /// 서버와 통신 중임을 나타내는 변수
    let isFetching: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    /// 새로고침 여부를 나타내는 변수
    let isRefreshing: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    /// 선택된 공지 종류
    /// 외부에서 변경되면 최신 값으로 공지를 가져오도록 사용
    private var category: Category? {
        didSet {
            fetchNotices()
        }
    }
    /// Publisher 구독 메모리 관리를 위한 cancellable bag
    private var cancellables: Set<AnyCancellable> = []
    /// 콘솔 메시지 로깅을 위한 인스턴스
    private var logger: Logger = Logger()
    
    init(category: Category?) {
        self.category = category
    }
    
    /// 서버에 `category`에 대한 공지사항 데이터 요청하고,
    /// 전달 받은 데이터는 `notices`에 업데이트
    func fetchNotices(isRefreshing: Bool = false) {
        guard let category = category else { return }
        
        requestNotices(category: category, isRefreshing: isRefreshing, update: .replace)
    }
    
    /// 외부에서 선택된 공지 카테고리 업데이트
    func updateSelectedMajor(_ category: Category?) {
        self.category = category
    }
    
    /// 무한 스크롤 구현을 위해 다음 페이지 공지사항 요청하고,
    /// 전달 받은 데이터는 `notices`에 추가 후 업데이트
    func fetchNextPage() {
        guard let category = category,
              let lastNum = notices.value.first?.items.last?.id,
              let count = notices.value.first?.items.count, count >= 20 else {
            return
        }
        
        requestNotices(category: category, after: lastNum, update: .append)
    }
}

extension NoticeCollectionViewModel {
    private enum UpdateStrategy {
        case replace
        case append
    }

    private func requestNotices(
        category: Category,
        after: Int? = nil,
        isRefreshing: Bool = false,
        update: UpdateStrategy
    ) {
        if isRefreshing {
            self.isRefreshing.accept(true)
        } else {
            self.isFetching.accept(true)
        }
        
        repository.fetchNotices(for: category.rawValue, after: after)
            .map { NoticeSectionModel(items: $0) }
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
                    self?.logger.error("NoticeCollectionViewModel error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] notices in
                print(notices.items)
                guard let self else { return }
                
                switch update {
                case .replace:
                    self.notices.accept([notices])
                case .append:
                    var current = self.notices.value.first
                    current?.items.append(contentsOf: notices.items)
                    if let current {
                        self.notices.accept([current])
                    }
                }
            })
            .store(in: &cancellables)
    }
}
