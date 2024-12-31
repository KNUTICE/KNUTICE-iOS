//
//  GeneralNoticeRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift

final class NoticeRepositoryImpl<N: NoticeDataSource>: NoticeRepository, NoticeCreatable {
    private let dataSource: N
    private let remoteURL: String
    
    init(dataSource: N, remoteURL: String) {
        self.dataSource = dataSource
        self.remoteURL = remoteURL
    }
    
    func fetchNotices() -> Single<[Notice]> {
        return dataSource.fetchNotices(from: remoteURL)
            .map { [weak self] in
                return self?.converToNotice($0) ?? []
            }
    }
    
    func fetchNotices(after number: Int) -> Single<[Notice]> {
        return dataSource.fetchNotices(from: self.remoteURL + "&nttId=\(number)")
            .map { [weak self] in
                return self?.converToNotice($0) ?? []
            }
    }
}
