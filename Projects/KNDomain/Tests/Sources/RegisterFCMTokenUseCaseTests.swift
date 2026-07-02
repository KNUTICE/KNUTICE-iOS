//
//  RegisterFCMTokenUseCaseTest.swift
//  KNTokenTests
//
//  Created by 이정훈 on 3/26/26.
//

import Factory
import KNData
import KNNetwork
@testable import KNDomain
import KNUtility
import Testing

struct RegisterFCMTokenUseCaseTests {
    private let registerFCMTokenUseCase: RegisterFCMTokenUseCase
    
    init() {
        self.registerFCMTokenUseCase = RegisterFCMTokenUseCase(repository: MockTokenRepository())
    }
    
    @Test("RegisterFCMTokenUseCase 성공 케이스 테스트")
    func registerFCMToken() async throws {
        // Given: 테스트에 필요한 상태 설정        
        let testToken = "sample_fcm_token"
        
        // When: 테스트 실행
        try await registerFCMTokenUseCase.execute(token: testToken)
        
        // Then: 기대 결과 검증
        #expect(true)
    }
}
