//
//  ProvideReloadEventPublisherUseCase.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/19/25.
//

@preconcurrency import Combine
import Factory
import Foundation

public protocol ProvideReloadEventPublisherUseCase {
    /// A stream of `ReloadEvent` events published by the repository layer.
    ///
    /// Subscribers can observe this publisher to update UI or re-fetch data
    /// in response to changes such as bookmark insertions, deletions, or updates.
    var eventPublisher: AnyPublisher<ReloadEvent, Never> { get }
}

public final class ProvideReloadEventPublisherUseCaseImpl: ProvideReloadEventPublisherUseCase {
    private let repository: BookmarkRepository
    
    public init(repository: BookmarkRepository) {
        self.repository = repository
    }
    
    /// Returns the repository’s reload event publisher.
    public var eventPublisher: AnyPublisher<ReloadEvent, Never> {
        repository.eventPublisher
    }
}
