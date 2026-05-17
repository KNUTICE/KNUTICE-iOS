//
//  NoticeCollectionViewModelTests.swift
//  KNCoreTests
//
//  Created by 이정훈 on 9/14/25.
//

import Factory
import KNDomain
@testable import KNNotice
import KNUtility
import Testing
import TestSupport
import RxSwift
import RxRelay

extension Container {
    var fetchNoticesUseCase: Factory<FetchNoticesUseCase> {
        Factory(self) { FetchNoticesUseCaseImpl(noticeRepository: Container.shared.noticeRepository.resolve()) }
    }
    
    var noticeRepository: Factory<NoticeRepository> {
        Factory(self) { MockNoticeRepository() }
    }
}

@Suite(.serialized) // 의존성 주입 혼선을 방지하기 위해 순차 실행
struct NoticeCollectionViewModelTests {
    private let disposeBag = DisposeBag()

    @MainActor
    @Test(arguments: NoticeCategory.allCases)
    func fetchNotices_데이터를_성공적으로_가져오는지_검증(for category: NoticeCategory) async throws {
        // given
        let fetchNoticesUseCase = Container.shared.fetchNoticesUseCase.resolve()
        let viewModel = NoticeCollectionViewModel(
            category: category,
            fetchNoticesUseCase: fetchNoticesUseCase
        )
        
        // 비동기 기대를 위한 confirmation
        try await confirmation("공지사항 데이터가 로드되어야 함", expectedCount: 1) { confirmation in
            // then: 데이터 방출 관찰
            viewModel.notices
                .skip(1)    // 초기값 [] 무시
                .subscribe(onNext: { sections in
                    if let items = sections.first?.items, !items.isEmpty {
                        // 각 카테고리별 샘플 데이터 개수 검증 (샘플 데이터는 카테고리별 2개씩 존재)
                        #expect(items.count >= 2)
                        #expect(items.allSatisfy { $0.category.rawValue == category.rawValue })
                        confirmation()
                    }
                })
                .disposed(by: disposeBag)

            // when
            viewModel.fetchNotices()
            
            // Task가 완료될 때까지 잠시 대기 (비동기 처리 보장)
            try await Task.sleep(nanoseconds: 100_000_000)
        }
    }

    @MainActor
    @Test("로딩_상태_변화_검증")
    func loadingState_검증() async throws {
        // given
        let viewModel = NoticeCollectionViewModel(
            category: NoticeCategory.academicNotice,
            fetchNoticesUseCase: Container.shared.fetchNoticesUseCase.resolve()
        )

        // when & then
        #expect(viewModel.isFetching.value == false)
        
        viewModel.fetchNotices()
        
        #expect(viewModel.isFetching.value == true)
        
        try await Task.sleep(nanoseconds: 200_000_000)
        
        #expect(viewModel.isFetching.value == false)
    }
}
