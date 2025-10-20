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

typealias NoticeCollectionViewModelProtocol = NoticeSectionModelProvidable & NoticeFetchable & MajorCategoryProvidable

@MainActor
final class NoticeCollectionViewModel<Category>: NoticeCollectionViewModelProtocol where Category: RawRepresentable & Sendable, Category.RawValue == String {
    /// View와 바인딩할 데이터
    /// 서버에서 가져온 데이터를 해당 변수에 저장
    let notices: BehaviorRelay<[NoticeSectionModel]> = BehaviorRelay(value: [])
    /// 공지사항 데이터 요청을 위한 `NoticeRepository` 인스턴스
    @Injected(\.fetchNoticeUseCase) private var fetchNoticeUseCase
    /// 서버와 통신 중임을 나타내는 변수
    let isFetching: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    /// 새로고침 여부를 나타내는 변수
    let isRefreshing: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    /// 선택된 공지 종류
    /// 외부에서 변경되면 최신 값으로 공지를 가져오도록 사용
    @Published var category: Category?
    /// Publisher 구독 메모리 관리를 위한 cancellable bag
    private var cancellables: Set<AnyCancellable> = []
    private(set) var task: Task<Void, Never>?
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
    
    /// `category` 값의 변화를 감지하여 공지 데이터를 자동으로 갱신합니다.
    ///
    /// - Description:
    ///   `@Published`로 선언된 `category`가 변경될 때마다 Combine의 `sink`를 통해
    ///   해당 카테고리의 공지 데이터를 새로 요청합니다.
    ///   이전 데이터를 초기화한 뒤, `requestNotices(category:update:)`를 호출하여
    ///   최신 공지 목록을 `notices`에 업데이트합니다.
    ///
    /// - Note:
    ///   `compactMap`을 사용해 `nil` 값은 무시하며,
    ///   전달받은 `category` 값을 직접 사용하여 비동기 타이밍 문제를 방지합니다.
    func bindWithCategory() {
        $category
            .compactMap { $0 }    // nil인 경우 제외
            .sink(receiveValue: { [weak self] category in
                // 기존 데이터 초기화
                self?.notices.accept([])
                // 새로운 공지 서버에서 가져오기
                self?.requestNotices(category: category, update: .replace)
            })
            .store(in: &cancellables)
    }
}

extension NoticeCollectionViewModel {
    private enum UpdateStrategy {
        case replace
        case append
    }

    private func requestNotices(
        category: Category,
        after nttId: Int? = nil,
        isRefreshing: Bool = false,
        update: UpdateStrategy
    ) {
        if isRefreshing {
            self.isRefreshing.accept(true)
        } else {
            self.isFetching.accept(true)
        }
        
        task = Task {
            defer {
                if isRefreshing {
                    self.isRefreshing.accept(false)
                } else {
                    self.isFetching.accept(false)
                }
            }
            
            do {
                let notices = try await fetchNoticeUseCase.execute(category: category, after: nttId)
                let sectionModel = NoticeSectionModel(items: notices)
                
                switch update {
                case .replace:
                    self.notices.accept([sectionModel])
                case .append:
                    var current = self.notices.value.first
                    current?.items.append(contentsOf: sectionModel.items)
                    if let current {
                        self.notices.accept([current])
                    }
                }
            } catch {
                logger.error("NoticeCollectionViewModel error: \(error.localizedDescription)")
            }
        }
    }
    
}

