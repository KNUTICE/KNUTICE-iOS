//
//  Container+Instance.swift
//  KNNotice
//
//  Created by 이정훈 on 1/5/26.
//

import Factory
import KNNetwork

public extension Container {
    var fetchTopThreeNoticesUseCase: Factory<FetchTopThreeNoticesUseCase> {
        Factory(self) {
            FetchTopThreeNoticesUseCaseImpl(repository: Container.shared.noticeRepository())
        }
    }
    
    var fetchNoticesUseCase: Factory<FetchNoticesUseCase> {
        Factory(self) {
            FetchNoticesUseCaseImpl()
        }
    }
    
    var searchNoticesUseCase: Factory<SearchNoticesUseCase> {
        Factory(self) {
            SearchNoticesUseCaseImpl()
        }
    }
    
    var noticeRepository: Factory<NoticeRepository> {
        Factory(self) {
            NoticeRepositoryImpl(dataSource: Container.shared.remoteDataSource())
        }
    }
}

extension Container {
    var topicSubscriptionRepository: Factory<TopicSubscriptionRepository> {
        Factory(self) {
            TopicSubscriptionRepositoryImpl()
        }
    }
}
