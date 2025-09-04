//
//  Container+Instance.swift
//  KNUTICECore
//
//  Created by 이정훈 on 8/6/25.
//

import Factory

public extension Container {
    //MARK: - RemoteDataSource
    var remoteDataSource: Factory<RemoteDataSource> {
        Factory(self) {
            RemoteDataSourceImpl()
        }
    }
    
    //MARK: - NoticeRepository
    var noticeRepository: Factory<NoticeRepository> {
        Factory(self) {
            NoticeRepositoryImpl()
        }
    }
}
