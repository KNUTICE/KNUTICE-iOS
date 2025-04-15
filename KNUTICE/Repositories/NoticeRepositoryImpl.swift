//
//  GeneralNoticeRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift
import Combine
import Factory

final class NoticeRepositoryImpl: NoticeRepository, NoticeCreatable {
    @Injected(\.remoteDataSource) private var dataSource: RemoteDataSource
    
    @available(*, deprecated, message: "Use Combine instead.")
    func fetchNotices(for category: NoticeCategory) -> Single<[Notice]> {
        return dataSource.sendGetRequest(to: category.remoteURL, resultType: NoticeReponseDTO.self)
            .map { [weak self] in
                return self?.createNotice($0) ?? []
            }
    }
    
    @available(*, deprecated, message: "Use Combine instead.")
    func fetchNotices(for category: NoticeCategory, after number: Int) -> Single<[Notice]> {
        return dataSource.sendGetRequest(to: category.remoteURL + "&nttId=\(number)", resultType: NoticeReponseDTO.self)
            .map { [weak self] in
                return self?.createNotice($0) ?? []
            }
    }
    
    func fetchNotices(for category: NoticeCategory) -> AnyPublisher<[Notice], any Error> {
        return dataSource.sendGetRequest(to: category.remoteURL, resultType: NoticeReponseDTO.self)
            .compactMap { [weak self] in
                self?.createNotice($0)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchNotices(for category: NoticeCategory, after number: Int) -> AnyPublisher<[Notice], any Error> {
        return dataSource.sendGetRequest(to: category.remoteURL + "&nttId=\(number)", resultType: NoticeReponseDTO.self)
            .compactMap { [weak self] in
                self?.createNotice($0)
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

fileprivate extension NoticeCategory {
    var remoteURL: String {
        switch self {
        case .generalNotice:
            return Bundle.main.generalNoticeURL
        case .academicNotice:
            return Bundle.main.academicNoticeURL
        case .scholarshipNotice:
            return Bundle.main.scholarshipNoticeURL
        case .eventNotice:
            return Bundle.main.eventNoticeURL
        }
    }
}
