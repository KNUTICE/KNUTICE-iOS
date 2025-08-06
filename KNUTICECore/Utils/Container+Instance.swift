//
//  Container+Instance.swift
//  KNUTICECore
//
//  Created by 이정훈 on 8/6/25.
//

import Factory

public extension Container {
    //MARK: - RemoteDataSource
    public var remoteDataSource: Factory<RemoteDataSource> {
        Factory(self) {
            RemoteDataSourceImpl()
        }
    }
}
