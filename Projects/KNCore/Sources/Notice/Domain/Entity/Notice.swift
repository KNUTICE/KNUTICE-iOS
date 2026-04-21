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
        isNew: Bool = false
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
        lhs.id == rhs.id
    }
}

#if DEBUG
public extension Notice {
    static var academicNoticesSample: [Notice] {
        return [
            Notice(
                id: 1,
                title: "2024학년도 2학기 재입학 신청 안내",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000055/selectBoardArticle.do",
                isSummarizable: false,
                department: "학사관리과",
                uploadDate: "2024-05-09",
                imageUrl: nil,
                category: NoticeCategory.academicNotice
            ),
            Notice(
                id: 2,
                title: "[충청권 국립대학] 2024학년도 한밭대,한국교원대,공주대 하계 계절학기 학점교류 안내",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000055/selectBoardArticle.do",
                isSummarizable: false,
                department: "학사관리과",
                uploadDate: "2024-05-08",
                imageUrl: nil,
                category: NoticeCategory.academicNotice
            ),
            Notice(
                id: 3,
                title: "2024-1학기 수업일수 3/4이상 수강한 휴학생 성적인정 신청 안내",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000055/selectBoardArticle.do",
                isSummarizable: false,
                department: "학사관리과",
                uploadDate: "2024-05-02",
                imageUrl: nil,
                category: NoticeCategory.academicNotice
            )
        ]
    }
    
    static var generalNoticesSample: [Notice] {
        return [
            Notice(
                id: 4,
                title: "2024학년도 1학기 분할납부(4차) 안내(5.13.~5.16.)",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000059/selectBoardArticle.do",
                isSummarizable: false,
                department: "재무과",
                uploadDate: "2024-05-10",
                imageUrl: nil,
                category: NoticeCategory.generalNotice
            ),
            Notice(
                id: 5,
                title: "[연구인력혁신센터] 중소기업 연구인력 현장맞춤형 양성지원 R&D인턴(채용연계형) 모집",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000059/selectBoardArticle.do",
                isSummarizable: false,
                department: "연구인력혁신센터",
                uploadDate: "2024-05-08",
                imageUrl: nil,
                category: NoticeCategory.generalNotice
            ),
            Notice(
                id: 6,
                title: "★ 2024학년도 취업동아리 참가학생 추가모집 안내 ★",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000059/selectBoardArticle.do",
                isSummarizable: false,
                department: "취업성공지원과",
                uploadDate: "2024-05-07",
                imageUrl: nil,
                category: NoticeCategory.generalNotice
            )
        ]
    }
    
    static var scholarshipNoticesSample: [Notice] {
        return [
            Notice(
                id: 7,
                title: "2024년도 상반기 강화군 대학생 등록금 지원 사업 안내",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000060/selectBoardArticle.do",
                isSummarizable: false,
                department: "장학팀",
                uploadDate: "2024-05-14",
                imageUrl: nil,
                category: NoticeCategory.scholarshipNotice
            ),
            Notice(
                id: 8,
                title: "2024년 국가우수장학(이공계) 성적우수유형 및 재학중우수자(2년지원)유형 선발계획 안내",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000060/selectBoardArticle.do",
                isSummarizable: false,
                department: "장학팀",
                uploadDate: "2024-05-07",
                imageUrl: nil,
                category: NoticeCategory.scholarshipNotice
            ),
            Notice(
                id: 9,
                title: "2024년 화성시인재육성재단 주거비지원 장학생 선발 안내",
                contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000060/selectBoardArticle.do",
                isSummarizable: false,
                department: "장학팀",
                uploadDate: "2024-05-03",
                imageUrl: nil,
                category: NoticeCategory.scholarshipNotice
            )
        ]
    }
}
#endif
