//
//  Notice.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/11/24.
//

import Foundation

struct Notice {
    let id: Int    //nttId
    let boardNumber: Int?
    let title: String    //제목
    let contentUrl: String    //화면 전환 시 이동할 사이트 URL
    let department: String    //부서
    let uploadDate: String    //등록 날짜
    let imageUrl: String?
}

#if DEBUG
extension Notice {
    static var academicNoticesSampleData: [Notice] {
        return [
            Notice(id: 1, 
                   boardNumber: 1,
                   title: "2024학년도 2학기 재입학 신청 안내",
                   contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000055/selectBoardArticle.do",
                   department: "학사관리과",
                   uploadDate: "2024-05-09", 
                   imageUrl: nil),
            Notice(id: 2,
                   boardNumber: 2,
                   title: "[충청권 국립대학] 2024학년도 한밭대,한국교원대,공주대 하계 계절학기 학점교류 안내",
                   contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000055/selectBoardArticle.do",
                   department: "학사관리과",
                   uploadDate: "2024-05-08",
                   imageUrl: nil),
            Notice(id: 3,
                   boardNumber: 3,
                   title: "2024-1학기 수업일수 3/4이상 수강한 휴학생 성적인정 신청 안내",
                   contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000055/selectBoardArticle.do",
                   department: "학사관리과",
                   uploadDate: "2024-05-02", 
                   imageUrl: nil)
        ]
    }
    
    static var generalNoticesSampleData: [Notice] {
        return [
            Notice(id: 4, 
                   boardNumber: 1,
                   title: "2024학년도 1학기 분할납부(4차) 안내(5.13.~5.16.)",
                   contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000059/selectBoardArticle.do",
                   department: "재무과",
                   uploadDate: "2024-05-10", 
                   imageUrl: nil),
            Notice(id: 5,
                   boardNumber: 2,
                   title: "[연구인력혁신센터] 중소기업 연구인력 현장맞춤형 양성지원 R&D인턴(채용연계형) 모집",
                   contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000059/selectBoardArticle.do",
                   department: "연구인력혁신센터",
                   uploadDate: "2024-05-08", 
                   imageUrl: nil),
            Notice(id: 6,
                   boardNumber: 3,
                   title: "★ 2024학년도 취업동아리 참가학생 추가모집 안내 ★",
                   contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000059/selectBoardArticle.do",
                   department: "취업성공지원과",
                   uploadDate: "2024-05-07",
                   imageUrl: nil)
        ]
    }
    
    static var scholarshipNoticesSampleData: [Notice] {
        return [
            Notice(id: 7,
                   boardNumber: 1,
                   title: "2024년도 상반기 강화군 대학생 등록금 지원 사업 안내",
                   contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000060/selectBoardArticle.do",
                   department: "장학팀",
                   uploadDate: "2024-05-14",
                   imageUrl: nil),
            Notice(id: 8,
                   boardNumber: 2,
                   title: "2024년 국가우수장학(이공계) 성적우수유형 및 재학중우수자(2년지원)유형 선발계획 안내",
                   contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000060/selectBoardArticle.do",
                   department: "장학팀",
                   uploadDate: "2024-05-07",
                   imageUrl: nil),
            Notice(id: 9,
                   boardNumber: 3,
                   title: "2024년 화성시인재육성재단 주거비지원 장학생 선발 안내",
                   contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000060/selectBoardArticle.do",
                   department: "장학팀",
                   uploadDate: "2024-05-03",
                   imageUrl: nil),
        ]
    }
    
    static var eventNoticesSampleData: [Notice] {
        return [
            Notice(id: 10,
                   boardNumber: 1,
                   title: "2024 일상 속 장애이슈 개선활동 청년 단체 모집",
                   contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000061/selectBoardArticle.do",
                   department: "학생과",
                   uploadDate: "2024-05-14",
                   imageUrl: nil),
            Notice(id: 11,
                   boardNumber: 2,
                   title: "한국저작권보호원 2024「바로 지금 대학생 서포터즈」모집",
                   contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000061/selectBoardArticle.do",
                   department: "학생과",
                   uploadDate: "2024-05-10",
                   imageUrl: nil),
            Notice(id: 12,
                   boardNumber: 3,
                   title: "‘2024 대한민국 열린 토론대회’ 논제 공모",
                   contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000061/selectBoardArticle.do",
                   department: "학생과",
                   uploadDate: "2024-05-10",
                   imageUrl: nil)
        ]
    }
}
#endif
