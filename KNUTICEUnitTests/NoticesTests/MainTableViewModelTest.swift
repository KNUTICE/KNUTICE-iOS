//
//  MainNoticesViewModelMockTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 3/3/25.
//

import Alamofire
import Factory
import RxSwift
import XCTest
import KNUTICECore
@testable import KNUTICE

final class MainTableViewModelTest: XCTestCase {
    private var viewModel: MainTableViewModel!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        Container.shared.fetchTopThreeNoticesUseCase.register {
            FetchTopThreeNoticesUseCaseImpl(repository: MockNoticeRepository())
        }
        
        viewModel = Container.shared.mainViewModel()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        disposeBag = nil
    }
    
    @MainActor
    func test_fetchNotices_emitActualNotices() {
        // Given
        let expectation = expectation(description: "actual notices emitted")
        
        viewModel.noticesObservable
            .filter { sections in
                // 실제 데이터 조건:
                // - 섹션이 모두 존재
                // - 각 섹션에 아이템 3개
                // - presentationType이 .actual인지 확인
                sections.count == NoticeCategory.allCases.count &&
                sections.allSatisfy { $0.items.count == 3 } &&
                sections.allSatisfy { $0.items.allSatisfy { $0.presentationType == .actual } }
            }
            .subscribe(onNext: { sections in
                // Then
                XCTAssertEqual(sections.count, NoticeCategory.allCases.count)
                
                sections.forEach { section in
                    XCTAssertEqual(section.items.count, 3)
                    
                    // skeleton이 아닌 실제 데이터인지 확인
                    XCTAssertTrue(
                        section.items.allSatisfy {
                            $0.presentationType == .actual
                        }
                    )
                }
                
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        // When
        viewModel.fetchNotices()
        wait(for: [expectation], timeout: 1.0)
    }

}
