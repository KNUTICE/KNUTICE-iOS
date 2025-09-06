//
//  TabBarService.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/25/25.
//

import Combine
import Factory
import Foundation
import KNUTICECore

protocol TabBarService {
    func fetchPushNotice() -> AnyPublisher<Notice?, any Error>
}

final class TabBarServiceImpl: TabBarService {
    @Injected(\.noticeRepository) private var noticeRepository: NoticeRepository
    
    func fetchPushNotice() -> AnyPublisher<Notice?, any Error> {
        let userInfo: [AnyHashable: Any]? = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.pushNotice.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.pushNotice.rawValue)
        
        if let nttIdStr = userInfo?["nttId"] as? String, let nttId = Int(nttIdStr) {
            return noticeRepository.fetchNotice(by: nttId)
        }
        
        return Fail(error: UserInfoError.nttIdNotFound(message: "nttId is not found"))
            .eraseToAnyPublisher()
    }
}
