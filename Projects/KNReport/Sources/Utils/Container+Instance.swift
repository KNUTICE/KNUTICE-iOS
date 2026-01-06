//
//  Container+Instance.swift
//  KNReport
//
//  Created by 이정훈 on 1/6/26.
//

import Factory

extension Container {
    var reportRepository: Factory<ReportRepository> {
        Factory(self) {
            ReportRepositoryImpl()
        }
    }
}
