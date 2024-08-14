//
//  MainNoticeRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import RxSwift

final class MainNoticeRepositoryImpl: MainNoticeRepository {
    private let dataSource: MainNoticeDataSource
    
    init(dataSource: MainNoticeDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchMainNotices() -> Observable<[SectionOfNotice]> {
        return dataSource.fetchMainNotices()
            .map { [weak self] in
                guard let dto = try? $0.get() else {
                    return []
                }
                
                return self?.convertToNotice(dto) ?? []
            }
    }
    
    private func convertToNotice(_ dto: MainNoticeDTO) -> [SectionOfNotice] {
        var sectionOfNotices = [SectionOfNotice]()
        
        //일반공지
        sectionOfNotices.append(
            SectionOfNotice(header: "일반소식",
                            items: dto.data.generalNewsTopThreeTitle.map {
                                MainNotice(id: $0.nttId,
                                           presentationType: .actual,
                                           title: $0.title,
                                           contentUrl: $0.contentUrl,
                                           department: $0.departName,
                                           uploadDate: $0.registrationDate)
                            })
        )
        
        //학사공지
        sectionOfNotices.append(
            SectionOfNotice(header: "학사공지",
                            items: dto.data.academicNewsTopThreeTitle.map {
                                MainNotice(id: $0.nttId, 
                                           presentationType: .actual,
                                           title: $0.title,
                                           contentUrl: $0.contentUrl,
                                           department: $0.departName,
                                           uploadDate: $0.registrationDate)
                            })
        )
        
        //장학공지
        sectionOfNotices.append(
            SectionOfNotice(header: "장학공지",
                            items: dto.data.scholarshipNewsTopThreeTitle.map {
                                MainNotice(id: $0.nttId, 
                                           presentationType: .actual,
                                           title: $0.title,
                                           contentUrl: $0.contentUrl,
                                           department: $0.departName,
                                           uploadDate: $0.registrationDate)
                            })
        )
        
        //행사안내
        sectionOfNotices.append(
            SectionOfNotice(header: "행사안내",
                            items: dto.data.eventNewsTopThreeTitle.map {
                                MainNotice(id: $0.nttId, 
                                           presentationType: .actual,
                                           title: $0.title,
                                           contentUrl: $0.contentUrl,
                                           department: $0.departName,
                                           uploadDate: $0.registrationDate)
                            })
        )
        
        return sectionOfNotices
    }
}
