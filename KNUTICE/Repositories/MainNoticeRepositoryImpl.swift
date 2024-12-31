//
//  MainNoticeRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import RxSwift

final class MainNoticeRepositoryImpl<T: MainNoticeDataSource>: MainNoticeRepository {
    private let dataSource: T
    
    init(dataSource: T) {
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
    
    private func convertToNotice(_ dto: MainNoticeResponseDTO) -> [SectionOfNotice] {
        var sectionOfNotices = [SectionOfNotice]()
        
        //일반공지
        sectionOfNotices.append(
            SectionOfNotice(header: "일반소식",
                            items: dto.body.latestThreeGeneralNews.map {
                                MainNotice(id: $0.nttID,
                                           presentationType: .actual,
                                           title: $0.title,
                                           contentUrl: $0.contentURL,
                                           department: $0.departName,
                                           uploadDate: $0.registeredAt)
                            }
                           )
        )
        
        //학사공지
        sectionOfNotices.append(
            SectionOfNotice(header: "학사공지",
                            items: dto.body.latestThreeAcademicNews.map {
                                MainNotice(id: $0.nttID,
                                           presentationType: .actual,
                                           title: $0.title,
                                           contentUrl: $0.contentURL,
                                           department: $0.departName,
                                           uploadDate: $0.registeredAt)
                            })
        )
        
        //장학공지
        sectionOfNotices.append(
            SectionOfNotice(header: "장학안내",
                            items: dto.body.latestThreeScholarshipNews.map {
                                MainNotice(id: $0.nttID,
                                           presentationType: .actual,
                                           title: $0.title,
                                           contentUrl: $0.contentURL,
                                           department: $0.departName,
                                           uploadDate: $0.registeredAt)
                            })
        )
        
        //행사안내
        sectionOfNotices.append(
            SectionOfNotice(header: "행사안내",
                            items: dto.body.latestThreeEventNews.map {
                                MainNotice(id: $0.nttID,
                                           presentationType: .actual,
                                           title: $0.title,
                                           contentUrl: $0.contentURL,
                                           department: $0.departName,
                                           uploadDate: $0.registeredAt)
                            })
        )
        
        return sectionOfNotices
    }
}
