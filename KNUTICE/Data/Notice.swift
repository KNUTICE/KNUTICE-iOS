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
}
#endif
