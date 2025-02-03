//
//  GeneralNoticeRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift
import Combine

final class NoticeRepositoryImpl<T: RemoteDataSource>: NoticeRepository, NoticeCreatable {
    private let dataSource: T
    private let remoteURL: String
    
    init(dataSource: T, remoteURL: String) {
        self.dataSource = dataSource
        self.remoteURL = remoteURL
    }
    
    @available(*, deprecated, message: "Use Combine instead.")
    func fetchNotices() -> Single<[Notice]> {
        return dataSource.sendGetRequest(to: remoteURL, resultType: NoticeReponseDTO.self)
            .map { [weak self] in
                return self?.converToNotice($0) ?? []
            }
    }
    
    @available(*, deprecated, message: "Use Combine instead.")
    func fetchNotices(after number: Int) -> Single<[Notice]> {
        return dataSource.sendGetRequest(to: self.remoteURL + "&nttId=\(number)", resultType: NoticeReponseDTO.self)
            .map { [weak self] in
                return self?.converToNotice($0) ?? []
            }
    }
    
    func fetchNotices() -> AnyPublisher<[Notice], any Error> {
        return dataSource.sendGetRequest(to: remoteURL, resultType: NoticeReponseDTO.self)
            .map { [weak self] in
                self?.converToNotice($0) ?? []
            }
            .eraseToAnyPublisher()
    }
    
    func fetchNotices(after number: Int) -> AnyPublisher<[Notice], any Error> {
        return dataSource.sendGetRequest(to: remoteURL + "&nttId=\(number)", resultType: NoticeReponseDTO.self)
            .map { [weak self] in
                self?.converToNotice($0) ?? []
            }
            .eraseToAnyPublisher()
    }
}
