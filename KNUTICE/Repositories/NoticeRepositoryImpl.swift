//
//  GeneralNoticeRepositoryImpl.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/22/24.
//

import RxSwift

final class NoticeRepositoryImpl: NoticeRepository {
    private let dataSource: NoticeDataSource
    private let remoteURL: String
    
    init(dataSource: NoticeDataSource, remoteURL: String) {
        self.dataSource = dataSource
        self.remoteURL = remoteURL
    }
    
    func fetchNotices() -> Observable<[Notice]> {
        return dataSource.fetchNotices(from: remoteURL)
            .map { [weak self] in
                guard let dto = try? $0.get() else {
                    return []
                }
                
                return self?.converToNotice(dto) ?? []
            }
    }
    
    func fetchNotices(after number: Int) -> Observable<[Notice]> {
        return dataSource.fetchNotices(from: self.remoteURL + "&nttId=\(number)")
            .map { [weak self] in
                guard let dto = try? $0.get() else {
                    return []
                }
                
                return self?.converToNotice(dto) ?? []
            }
    }
}
