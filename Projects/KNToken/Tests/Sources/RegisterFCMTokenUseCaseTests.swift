//
//  RegisterFCMTokenUseCaseTest.swift
//  KNTokenTests
//
//  Created by 이정훈 on 3/26/26.
//

import Factory
import KNNetwork
@testable import KNToken
import KNUtility
import Testing

struct RegisterFCMTokenUseCaseTests {
    @Test("RegisterFCMTokenUseCase 성공 케이스 테스트")
    func registerFCMToken() async throws {
        // Given: 테스트에 필요한 상태 설정
        Container.shared.tokenRepository.register {
            MockTokenRepository()
        }
        
        let testToken = "sample_fcm_token"
        let registerFCMTokenUseCase = Container.shared.registerFCMTokenUseCase()
        
        // When: 테스트 실행
        try await registerFCMTokenUseCase.execute(token: testToken)
        
        // Then: 기대 결과 검증
        #expect(true)
    }
    
    @Test("RegisterFCMTokenUseCase 실패 케이스 테스트")
    func registerFCMToken_failure() async throws {
        // Given: 테스트에 필요한 상태 설정
        Container.shared.tokenRepository.register {
            MockTokenRepository(shouldThrowError: true)
        }
        
        let testToken = "sample_fcm_token"
        let registerFCMTokenUseCase = Container.shared.registerFCMTokenUseCase()
        
        // When: 테스트 실행
        // Then: 기대 결과 검증
        await #expect(throws: NetworkError.remoteServerError(message: "Registration Failed")) {
            try await registerFCMTokenUseCase.execute(token: testToken)
        }
    }
}
