//
//  FetchTopThreeNoticesTest.swift
//  KNNoticeTests
//
//  Created by 이정훈 on 1/14/26.
//

import Factory
import Testing
@testable import KNNotice

@Test
func fetchTopThreeNotices_returnsThreeNoticesPerCategory() async throws {
    // Given
    Container.shared.noticeRepository.register {
        MockNoticeRepository()
    }

    let fetchTopThreeNoticesUseCase = Container.shared.fetchTopThreeNoticesUseCase()

    // When
    for try await value in fetchTopThreeNoticesUseCase.execute(isRefresh: true).values {
        // Then
        #expect(value.count == NoticeCategory.allCases.count)
        for section in value {
            #expect(section.items.count == 3)
            for item in section.items {
                #expect(item.presentationType == .actual)
            }
        }
        
        break
    }

}
