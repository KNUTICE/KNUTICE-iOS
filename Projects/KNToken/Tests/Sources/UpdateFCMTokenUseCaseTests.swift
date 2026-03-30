//
//  UpdateFCMTokenUseCaseTests.swift
//  KNTokenTests
//
//  Created by 이정훈 on 3/29/26.
//

import Factory
import KNNetwork
@testable import KNToken
import Testing

struct UpdateFCMTokenUseCaseTests {

    @Test("UpdateFCMTokenUseCase 성공 케이스 테스트")
    func updateFCMToken() async throws {
        // Given: 테스트에 필요한 상태 설정
        Container.shared.tokenRepository.register {
            MockTokenRepository()
        }
        
        let updateFCMTokenUseCase = Container.shared.updateFCMTokenUseCase()
        
        // When: 테스트 실행
        try await updateFCMTokenUseCase.execute()
        
        // Then: 기대 결과 검증
        #expect(true)
    }

    @Test("UpdateFCMTokenUseCase 실패 케이스 테스트")
    func updateFCMToken_failure() async throws {
        // Given: 테스트에 필요한 상태 설정
        Container.shared.tokenRepository.register {
            MockTokenRepository(shouldThrowError: true)
        }
        
        let updateFCMTokenUseCase = Container.shared.updateFCMTokenUseCase()
        
        // When: 테스트 실행
        // Then: 기대 결과 검증
        await #expect(throws: NetworkError.remoteServerError(message: "Update Failed")) {
            try await updateFCMTokenUseCase.execute()
        }
    }
}
