//
//  Container+Instance.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 3/13/26.
//

import Factory

extension Container {
    var readingRoomRepository: Factory<ReadingRoomRepository> {
        Factory(self) {
            ReadingRoomRepositoryImpl()
        }
    }
}
