//
//  MainPopupContentRepository.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/22/25.
//

import Combine

protocol MainPopupContentRepository {
    func fetchMainPopupContent() -> AnyPublisher<MainPopupContent?, any Error>
}

extension MainPopupContentRepository {
    func createMainPopupContent(from dto: MainPopupContentDTO) -> MainPopupContent? {
        guard let body = dto.body else { return nil }
        
        return .init(
            title: body.title,
            content: body.content,
            contentURL: body.contentURL,
            registeredDate: body.registeredAt
        )
    }
}
