//
//  ProvideReloadEventPublisherUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/19/25.
//

@preconcurrency import Combine
import Factory
import Foundation

protocol ProvideReloadEventPublisherUseCase {
    /// A stream of `ReloadEvent` events published by the repository layer.
    ///
    /// Subscribers can observe this publisher to update UI or re-fetch data
    /// in response to changes such as bookmark insertions, deletions, or updates.
    var eventPublisher: AnyPublisher<ReloadEvent, Never> { get }
}

final class ProvideReloadEventPublisherUseCaseImpl: ProvideReloadEventPublisherUseCase {
    @Injected(\.bookmarkRepository) private var repository
    
    /// Returns the repository’s reload event publisher.
    var eventPublisher: AnyPublisher<ReloadEvent, Never> {
        repository.eventPublisher
    }
}
