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
            .map { [weak self] in
                self?.createNotice($0) ?? []
            }
            .eraseToAnyPublisher()
    }
    
    func fetchNotices(for category: NoticeCategory, after number: Int) -> AnyPublisher<[Notice], any Error> {
        return dataSource.sendGetRequest(to: category.remoteURL + "&nttId=\(number)", resultType: NoticeReponseDTO.self)
            .map { [weak self] in
                self?.createNotice($0) ?? []
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
