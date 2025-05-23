//
//  GeneralNoticeRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift
import Combine
import Factory
import Foundation

final class NoticeRepositoryImpl: NoticeRepository, NoticeCreatable {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSource
    
    func fetchNotices(for category: NoticeCategory) -> AnyPublisher<NoticeSectionModel, any Error> {
        let endPoint = Bundle.main.noticeURL
        
        return dataSource.sendGetRequest(to: endPoint + "?noticeName=\(category.rawValue)", resultType: NoticeReponseDTO.self)
            .compactMap { [weak self] dto in
                dto.body?.compactMap {
                    self?.createNotice($0)
                }
            }
            .map {
                NoticeSectionModel(items: $0)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchNotices(for category: NoticeCategory, after number: Int) -> AnyPublisher<NoticeSectionModel, any Error> {
        let endPoint = Bundle.main.noticeURL
        
        return dataSource.sendGetRequest(to: endPoint + "?noticeName=\(category.rawValue)" + "&nttId=\(number)", resultType: NoticeReponseDTO.self)
            .compactMap { [weak self] dto in
                dto.body?.compactMap {
                    self?.createNotice($0)
                }
            }
            .map {
                NoticeSectionModel(items: $0)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchNotices(by nttIds: [Int]) -> AnyPublisher<[Notice], any Error> {
        let params: [String: Any] = [
            "result": [
                "resultCode": 0,
                "resultMessage": "string",
                "resultDescription": "string"
            ],
            "body": [
                "nttIdList": nttIds
            ]
        ]
        
        return dataSource.sendPostRequest(to: Bundle.main.noticeSyncURL, params: params, resultType: NoticeReponseDTO.self)
            .compactMap { [weak self] in
                self?.createNotice($0)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchNotice(by nttId: Int) -> AnyPublisher<Notice?, any Error> {
        return dataSource.sendGetRequest(to: Bundle.main.mainNoticeURL + "/\(nttId)", resultType: SingleNoticeResponseDTO.self)
            .map { [weak self] dto in
                return dto.body.flatMap {
                    self?.createNotice($0)
                }
            }
            .eraseToAnyPublisher()
    }
}
