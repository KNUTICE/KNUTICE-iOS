//
//  MainNoticeRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/19/24.
//

import RxSwift
import Combine
import Factory

final class MainNoticeRepositoryImpl: MainNoticeRepository {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSource
    
    ///GET 요청 함수 with RxSwift
    @available(*, deprecated)
    func fetchMainNotices() -> Observable<[SectionOfNotice]> {
        return dataSource.sendGetRequest(to: Bundle.main.mainNoticeURL, resultType: MainNoticeResponseDTO.self)
            .map { [weak self] in
                return self?.createScectionOfNotice($0) ?? []
            }
            .asObservable()
    }
    
    ///GET 요청 함수 with Combine
    func fetch() -> AnyPublisher<[SectionOfNotice], any Error> {
        return dataSource.sendGetRequest(to: Bundle.main.mainNoticeURL, resultType: MainNoticeResponseDTO.self)
            .map { [weak self] in
                self?.createScectionOfNotice($0) ?? []
            }
            .eraseToAnyPublisher()
    }
    
    private func createScectionOfNotice(_ dto: MainNoticeResponseDTO) -> [SectionOfNotice] {
        var sectionOfNotices = [SectionOfNotice]()
        
        //일반공지
        sectionOfNotices.append(
            SectionOfNotice(header: "일반소식",
                            items: dto.body.latestThreeGeneralNews.map {
                                MainNotice(presentationType: .actual,
                                           notice: createNotice($0))
                            })
        )
        
        //학사공지
        sectionOfNotices.append(
            SectionOfNotice(header: "학사공지",
                            items: dto.body.latestThreeAcademicNews.map {
                                MainNotice(presentationType: .actual,
                                           notice: createNotice($0))
                            })
        )
        
        //장학공지
        sectionOfNotices.append(
            SectionOfNotice(header: "장학안내",
                            items: dto.body.latestThreeScholarshipNews.map {
                                MainNotice(presentationType: .actual,
                                           notice: createNotice($0))
                            })
        )
        
        //행사안내
        sectionOfNotices.append(
            SectionOfNotice(header: "행사안내",
                            items: dto.body.latestThreeEventNews.map {
                                MainNotice(presentationType: .actual,
                                           notice: createNotice($0))
                            })
        )
        
        return sectionOfNotices
    }
    
    private func createNotice(_ body: NoticeReponseBody) -> Notice {
        Notice(
            id: body.nttID,
            title: body.title,
            contentUrl: body.contentURL,
            department: body.departmentName,
            uploadDate: body.registeredAt,
            imageUrl: body.contentImage,
            noticeCategory: NoticeCategory(rawValue: body.noticeName)
        )
    }
    
    func fetchTempData() -> AnyPublisher<[SectionOfNotice], any Error> {
        let notices =  [
            SectionOfNotice(header: "일반소식",
                            items: Array(repeating: MainNotice(presentationType: .skeleton, notice: createTempNotice()), count: 3)),
                    
            SectionOfNotice(header: "학사공지",
                            items: Array(repeating: MainNotice(presentationType: .skeleton, notice: createTempNotice()), count: 3)),
            
            SectionOfNotice(header: "장학공지",
                            items: Array(repeating: MainNotice(presentationType: .skeleton, notice: createTempNotice()), count: 3)),
                    
            SectionOfNotice(header: "행사안내",
                            items: Array(repeating: MainNotice(presentationType: .skeleton, notice: createTempNotice()), count: 3))
        ]
        
        return Just(notices)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func createTempNotice() -> Notice {
        Notice(id: UUID().hashValue,
               title: " ",
               contentUrl: " ",
               department: " ",
               uploadDate: " ",
               imageUrl: nil,
               noticeCategory: nil)
    }
}
