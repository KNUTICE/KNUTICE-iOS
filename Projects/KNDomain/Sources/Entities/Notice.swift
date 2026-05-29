//
//  Notice.swift
//  KNNotice
//
//  Created by 이정훈 on 1/2/26.
//

import Foundation
import KNUtility

public struct Notice: Sendable, Equatable, Identifiable {
    public let id: Int    // nttId
    public let title: String    // 제목
    public let contentUrl: URL?    // 화면 전환 시 이동할 사이트 URL
    public let isSummarizable: Bool    // AI 요약 가능 여부
    public let department: String    // 부서
    public let uploadDate: String    // 등록 날짜
    public let imageUrl: String?    // 썸네일 URL
    public let category: any CategoryProtocol    // 공지 카테고리 종류
    public var isNew: Bool
    
    public init(
        id: Int,
        title: String,
        contentUrl: String,
        isSummarizable: Bool,
        department: String,
        uploadDate: String,
        imageUrl: String?,
        category: any CategoryProtocol,
        isNew: Bool
    ) {
        self.id = id
        self.title = title
        self.contentUrl = URL(string: contentUrl)
        self.isSummarizable = isSummarizable
        self.department = department
        self.uploadDate = uploadDate
        self.imageUrl = imageUrl
        self.category = category
        self.isNew = isNew
    }
    
    public static func == (lhs: Notice, rhs: Notice) -> Bool {
        lhs.id == rhs.id &&
        lhs.isNew == rhs.isNew &&
        lhs.category.rawValue == rhs.category.rawValue
    }
}

#if DEBUG
public extension Notice {
    static var academicNoticesSample: [Notice] {
        return [
            Notice(
                id: 1121917,
                title: "2026학년도 1학기 3C인재 인증 신청 안내",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000055/selectBoardArticle.do?nttId=1121917",
                isSummarizable: true,
                department: "학사관리과",
                uploadDate: "2026-05-11",
                imageUrl: nil,
                category: NoticeCategory.academicNotice,
                isNew: false
            ),
            Notice(
                id: 1121886,
                title: "2026학년도 하계 계절학기 수강신청 및 수강료 납부 안내",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000055/selectBoardArticle.do?nttId=1121886",
                isSummarizable: true,
                department: "학사관리과",
                uploadDate: "2026-05-07",
                imageUrl: nil,
                category: NoticeCategory.academicNotice,
                isNew: false
            )
        ]
    }
    
    static var generalNoticesSample: [Notice] {
        return [
            Notice(
                id: 1121959,
                title: "2026학년도 교내 온라인 모의토익/토익스피킹 실시 안내",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000059/selectBoardArticle.do?nttId=1121959",
                isSummarizable: true,
                department: "국제교류본부",
                uploadDate: "2026-05-12",
                imageUrl: nil,
                category: NoticeCategory.generalNotice,
                isNew: false
            ),
            Notice(
                id: 1121930,
                title: "📢[IPP사업단] 일학습병행 설명회 개최 안내📢",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000059/selectBoardArticle.do?nttId=1121930",
                isSummarizable: true,
                department: "IPP사업단",
                uploadDate: "2026-05-11",
                imageUrl: "https://www.ut.ac.kr/namo/binary/images/000106/20260511165256844_H46XWBBY.png",
                category: NoticeCategory.generalNotice,
                isNew: false
            )
        ]
    }
    
    static var scholarshipNoticesSample: [Notice] {
        return [
            Notice(
                id: 1121967,
                title: "2026학년도 1학기 OCU컨소시엄 장학생 선발 안내",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000060/selectBoardArticle.do?nttId=1121967",
                isSummarizable: true,
                department: "장학팀",
                uploadDate: "2026-05-12",
                imageUrl: nil,
                category: NoticeCategory.scholarshipNotice,
                isNew: false
            ),
            Notice(
                id: 1121915,
                title: "[홍보]세종이도인재 장학금 장학생 모집 안내",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000060/selectBoardArticle.do?nttId=1121915",
                isSummarizable: true,
                department: "장학팀",
                uploadDate: "2026-05-11",
                imageUrl: nil,
                category: NoticeCategory.scholarshipNotice,
                isNew: false
            )
        ]
    }

    static var eventNoticesSample: [Notice] {
        return [
            Notice(
                id: 1121966,
                title: "‘2026 한-프랑스 어학 보조교사 교류사업’ 한국어 보조교사 선발 안내",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000061/selectBoardArticle.do?nttId=1121966",
                isSummarizable: true,
                department: "학생과",
                uploadDate: "2026-05-12",
                imageUrl: nil,
                category: NoticeCategory.eventNotice,
                isNew: false
            ),
            Notice(
                id: 1121960,
                title: "기술보증기금 「2026년도 대국민 혁신 아이디어 공모전」",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000061/selectBoardArticle.do?nttId=1121960",
                isSummarizable: true,
                department: "학생과",
                uploadDate: "2026-05-12",
                imageUrl: nil,
                category: NoticeCategory.eventNotice,
                isNew: false
            )
        ]
    }

    static var employmentNoticesSample: [Notice] {
        return [
            Notice(
                id: 1121950,
                title: "[대학일자리플러스센터] 2026학년도 객원상담제 안내(충북지역 취업연계)",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000179/selectBoardArticle.do?nttId=1121950",
                isSummarizable: true,
                department: "대학일자리플러스센터",
                uploadDate: "2026-05-12",
                imageUrl: nil,
                category: NoticeCategory.employmentNotice,
                isNew: false
            ),
            Notice(
                id: 1121929,
                title: "2026 GLOBAL TALENT FAIR(채용박람회)",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000179/selectBoardArticle.do?nttId=1121929",
                isSummarizable: true,
                department: "대학일자리플러스센터",
                uploadDate: "2026-05-11",
                imageUrl: nil,
                category: NoticeCategory.employmentNotice,
                isNew: false
            )
        ]
    }
}
#endif
