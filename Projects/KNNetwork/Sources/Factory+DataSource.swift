//
//  Factory+DataSource.swift
//  KNNetwork
//
//  Created by 이정훈 on 1/3/26.
//

import Factory

public extension Container {
    var remoteDataSource: Factory<RemoteDataSource> {
        Factory(self) {
            RemoteDataSourceImpl()
        }
    }
}
