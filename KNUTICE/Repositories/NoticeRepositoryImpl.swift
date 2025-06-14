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
    
    func fetchNotices(for category: NoticeCategory) -> AnyPublisher<[Notice], any Error> {
        return dataSource.request(
            Bundle.main.noticeURL + "?noticeName=\(category.rawValue)",
            method: .get,
            decoding: NoticeReponseDTO.self
        )
        .compactMap { [weak self] dto in
            dto.body?.compactMap {
                self?.createNotice($0)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchNotices(for category: NoticeCategory, after number: Int) -> AnyPublisher<[Notice], any Error> {
        return dataSource.request(
            Bundle.main.noticeURL + "?noticeName=\(category.rawValue)" + "&nttId=\(number)",
            method: .get,
            decoding: NoticeReponseDTO.self
        )
        .compactMap { [weak self] dto in
            dto.body?.compactMap {
                self?.createNotice($0)
            }
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
        
        return dataSource.request(
            Bundle.main.noticeSyncURL,
            method: .post,
            parameters: params,
            decoding: NoticeReponseDTO.self
        )
        .compactMap { [weak self] dto in
            dto.body?.compactMap {
                self?.createNotice($0)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchNotice(by nttId: Int) -> AnyPublisher<Notice?, any Error> {
        return dataSource.request(
            Bundle.main.mainNoticeURL + "/\(nttId)",
            method: .get,
            decoding: SingleNoticeResponseDTO.self
        )
        .map { [weak self] dto in
            return dto.body.flatMap {
                self?.createNotice($0)
            }
        }
        .eraseToAnyPublisher()
    }
}
