//
//  UpdateFCMTokenUseCaseTests.swift
//  KNTokenTests
//
//  Created by 이정훈 on 3/29/26.
//

import Factory
import KNNetwork
@testable import KNDomain
import Testing

struct UpdateFCMTokenUseCaseTests {
    // Given: 테스트에 필요한 상태 설정
    private let updateFCMTokenUseCase = UpdateFCMTokenUseCase(repository: MockTokenRepository())

    @Test("UpdateFCMTokenUseCase 성공 케이스 테스트")
    func updateFCMToken() async throws {
        // When: 테스트 실행
        try await updateFCMTokenUseCase.execute()
        
        // Then: 기대 결과 검증
        #expect(true)
    }
}
