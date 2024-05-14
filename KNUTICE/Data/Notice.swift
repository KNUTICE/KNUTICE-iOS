//
//  Notice.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/11/24.
//

import Foundation

struct Notice {
    let id: Int
    let title: String
    let department: String
    let uploadDate: String
}

#if DEBUG
extension Notice {
    static var academicNoticesSampleData: [Notice] {
        return [
            Notice(id: 1,
                   title: "2024학년도 2학기 재입학 신청 안내",
                   department: "학사관리과",
                   uploadDate: "2024-05-09"),
            Notice(id: 2,
                   title: "[충청권 국립대학] 2024학년도 한밭대,한국교원대,공주대 하계 계절학기 학점교류 안내",
                   department: "학사관리과",
                   uploadDate: "2024-05-08"),
            Notice(id: 3,
                   title: "2024-1학기 수업일수 3/4이상 수강한 휴학생 성적인정 신청 안내",
                  department: "학사관리과",
                   uploadDate: "2024-05-02")
        ]
    }
    
    static var generalNoticesSampleData: [Notice] {
        return [
            Notice(id: 4,
                   title: "2024학년도 1학기 분할납부(4차) 안내(5.13.~5.16.)",
                   department: "재무과",
                   uploadDate: "2024-05-10"),
            Notice(id: 5,
                   title: "[연구인력혁신센터] 중소기업 연구인력 현장맞춤형 양성지원 R&D인턴(채용연계형) 모집",
                   department: "연구인력혁신센터",
                   uploadDate: "2024-05-08"),
            Notice(id: 6,
                   title: "★ 2024학년도 취업동아리 참가학생 추가모집 안내 ★",
                   department: "취업성공지원과",
                   uploadDate: "2024-05-07")
        ]
    }
    
    static var scholarshipNoticesSampleData: [Notice] {
        return [
            Notice(id: 7,
                   title: "2024년도 상반기 강화군 대학생 등록금 지원 사업 안내",
                   department: "장학팀",
                   uploadDate: "2024-05-14"),
            Notice(id: 8,
                   title: "2024년 국가우수장학(이공계) 성적우수유형 및 재학중우수자(2년지원)유형 선발계획 안내",
                   department: "장학팀",
                   uploadDate: "2024-05-07"),
            Notice(id: 9,
                   title: "2024년 화성시인재육성재단 주거비지원 장학생 선발 안내",
                   department: "장학팀",
                   uploadDate: "2024-05-03"),
        ]
    }
    
    static var eventNoticesSampleData: [Notice] {
        return [
            Notice(id: 10,
                   title: "2024 일상 속 장애이슈 개선활동 청년 단체 모집",
                   department: "학생과",
                   uploadDate: "2024-05-14"),
            Notice(id: 11,
                   title: "한국저작권보호원 2024「바로 지금 대학생 서포터즈」모집",
                   department: "학생과",
                   uploadDate: "2024-05-10"),
            Notice(id: 12,
                   title: "‘2024 대한민국 열린 토론대회’ 논제 공모",
                   department: "학생과",
                   uploadDate: "2024-05-10")
        ]
    }
}
#endif
