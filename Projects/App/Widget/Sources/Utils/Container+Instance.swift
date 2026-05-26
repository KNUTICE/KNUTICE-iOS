//
//  Container+Instance.swift
//  KNUTICEWidget
//
//  Created by 이정훈 on 5/26/26.
//

import Factory
import KNData
import KNDomain
import KNNetwork

extension Container {
    private var noticeRepository: Factory<NoticeRepository> {
        Factory(self) { NoticeRepositoryImpl(dataSource: RemoteDataSourceImpl()) }
    }
    
    var fetchNoticesUseCase: Factory<FetchNoticesUseCase> {
        Factory(self) { FetchNoticesUseCaseImpl(noticeRepository: self.noticeRepository()) }
    }
}
