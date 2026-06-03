//
//  FetchNoticeSummaryUseCaseTests.swift
//  KNIntelligenceTests
//
//  Created by 이정훈 on 3/17/26.
//

import Factory
@testable import KNDomain
import Testing

// MARK: - Mock
extension NoticeSummary {
    static let mock = NoticeSummary(
        id: 1087050,
        content: "## 2026학년도 창업동아리 모집 요약\n\n**1. 지원 대상:**\n\n*   우리 대학 재학생 및 대학원생 (휴학생 포함, 단 팀 대표는 불가)\n*   창업에 관심 있는 모든 학생\n\n**2. 접수 기간:**\n\n*   2026년 3월 9일 (월) ~ 3월 24일 (화) 17:00까지\n\n**3. 지원 내용 (단계별 지원금):**\n\n*   C1: 최대 100만원\n*   C2: 최대 300만원\n*   C3: 최대 500만원\n\n**4. 지원 방법:**\n\n*   신청서 작성 후 **압축 파일** 형태로 창업지원교육센터 이메일 (Knut-startup@ut.ac.kr) 접수\n\n**5. 문의:**\n\n*   창업지원교육센터: 043-849-1727 (국제청년협력센터 E18동 312호)"
    )
}

actor MockNoticeSummaryRepository: NoticeSummaryRepository {
    func fetch(for nttId: Int) async throws -> NoticeSummary {
        return .mock
    }
}

@Suite("FetchNoticeSummaryUseCase 테스트")
struct FetchNoticeSummaryUseCaseTests {
    private let usecase: FetchNoticeSummaryUseCase
    
    init() {
        usecase = FetchNoticeSummaryUseCaseImpl(repository: MockNoticeSummaryRepository())
    }

    @Test("공지사항 요약 데이터를 가져와 마크다운 노드로 변환하는 데 성공한다")
    func fetchNoticeSummaryMarkDown_shouldSuccess() async throws {
        // Given
        let targetId = 1087050
        
        // When
        let nodes = try await usecase.execute(for: targetId)
        
        // Then
        #expect(!nodes.isEmpty, "파싱된 마크다운 노드가 비어있지 않아야 합니다.")
    }
    
}
