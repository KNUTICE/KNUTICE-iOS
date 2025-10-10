//
//  NoticeCollectionViewModelTests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 9/14/25.
//

import Factory
import KNUTICECore
import Testing
import RxSwift
@testable import KNUTICE

struct NoticeCollectionViewModelTests {
    init() {
        Container.shared.noticeRepository.register {
            MockNoticeRepository()
        }
    }
    
    @MainActor
    @Test(arguments: NoticeCategory.allCases)
    func fetchNotices(for category: NoticeCategory) {
        // given: MockNoticeRepository와 ViewModel 준비
        let disposeBag = DisposeBag()
        let viewModel = NoticeCollectionViewModel(category: category)
        
        // then: fetchNotices 호출 시 Mock 데이터(3개)가 방출되는지 검증
        viewModel.notices
            .skip(1) // 초기값 방출은 무시
            .subscribe(onNext: {
                #expect($0.count == 3)
            })
            .disposed(by: disposeBag)
        
        // when: fetchNotices 메서드 실행
        viewModel.fetchNotices()
    }
}
