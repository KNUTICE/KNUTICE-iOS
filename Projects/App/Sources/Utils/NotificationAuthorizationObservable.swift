//
//  NotificationAuthorizationObservable.swift
//  KNUTICE
//
//  Created by 이정훈 on 11/6/25.
//

@preconcurrency import Combine
import Foundation

/// A singleton observable object that publishes notification authorization status changes.
///
/// `NotificationAuthorizationObservable` uses a `CurrentValueSubject` to store and
/// publish the latest authorization state. External callers can subscribe to
/// `publisher` to react to changes, but cannot modify the state directly.
///
/// This type is implemented as an `actor` to ensure thread-safe access and mutation.
///
/// Example:
///
/// ```swift
/// NotificationAuthorizationObservable.shared.publisher
///     .sink { isAuthorized in
///         print("Authorization changed:", isAuthorized)
///     }
///     .store(in: &cancellables)
/// ```
///
/// Use `send(_:)` to update the authorization state internally.
/// External consumers are only able to observe changes through the `publisher`.
final class NotificationAuthorizationObservable: Sendable {
    
    /// A shared singleton instance of the authorization observable.
    static let shared: NotificationAuthorizationObservable = .init()
    
    /// Internal subject that stores and publishes the latest authorization state.
    ///
    /// This subject is kept private to prevent external callers from emitting values.
    private let subject: CurrentValueSubject<Bool, Never> = .init(false)
    
    /// A read-only publisher that emits authorization status changes.
    ///
    /// This publisher exposes the subject without allowing external mutation.
    var publisher: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }
    
    /// Creates a new instance of the observable.
    ///
    /// This initializer is private to enforce singleton usage through `shared`.
    private init() {}
    
    /// Updates the current authorization state.
    ///
    /// - Parameter isAuthorized: A Boolean indicating whether notification
    ///   authorization is granted.
    ///
    /// Only internal components should call this method.
    /// External consumers should subscribe to `publisher` instead.
    func send(_ isAuthorized: Bool) {
        subject.send(isAuthorized)
    }
    
}
