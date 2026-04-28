//
//  Container+Instance.swift
//  KNData
//
//  Created by 이정훈 on 4/28/26.
//

import Factory
import KNDomain
import KNNetwork

public extension Container {
    var noticeRepository: Factory<NoticeRepository> {
        Factory(self) { NoticeRepositoryImpl(dataSource: RemoteDataSourceImpl()) }
    }
}
