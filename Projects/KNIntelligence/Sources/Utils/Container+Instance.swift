//
//  Container+Instance.swift
//  KNIntelligence
//
//  Created by 이정훈 on 1/29/26.
//

import Factory
import Foundation

extension Container {
    var noticeSummaryRepository: Factory<NoticeSummaryRepository> {
        Factory(self) {
            NoticeSummaryRepositoryImpl()
        }
    }
    
    var fetchNoticeSummaryUseCase: Factory<FetchNoticeSummaryUseCase> {
        Factory(self) {
            FetchNoticeSummaryUseCaseImpl()
        }
    }
}
