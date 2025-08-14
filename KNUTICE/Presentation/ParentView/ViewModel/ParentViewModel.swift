//
//  ParentViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/11/25.
//

import Combine
import Factory
import Foundation

@MainActor
final class ParentViewModel {
    //MARK: - Properties
    
    /// Indicates whether the view should navigate to the main screen.
    /// Set to `true` to trigger navigation, `false` to remain on the current view.
    @Published var shouldNavigateToMain: Bool = false
    
    /// The injected service responsible for handling FCM token registration and management.
    @Injected(\.fcmTokenService) private var service
    
    /// A set of Combine cancellables used to store subscriptions for automatic cancellation
    /// when the owning instance is deallocated.
    private var cancellables: Set<AnyCancellable> = []
    
    /// The currently running async task for FCM token registration or related work.
    /// Cancelling or overwriting this task will stop the in-progress operation.
    var task: Task<Void, Never>?
    
    //MARK: - Methods
    
    /// Subscribes to FCM token update notifications and registers the token with the server.
    ///
    /// This method listens for `.fcmToken` notifications posted via `NotificationCenter`.
    /// When a notification is received, it attempts to extract the `"token"` value from the `userInfo`
    /// dictionary and sends it to the `register(token:)` method for server registration.
    ///
    /// - Note:
    ///   - The `userInfo` dictionary of the `.fcmToken` notification must contain a `"token"` key with a `String` value.
    ///   - Uses a Combine `AnyCancellable` to store the subscription, which will be released when the instance is deallocated.
    ///   - `[weak self]` is used in the subscription closure to avoid retain cycles.
    ///
    /// - SeeAlso:
    ///   - `register(token:)` for the actual token registration implementation.
    ///   - `.fcmToken` for the notification definition.
    func subscribeToFCMToken() {
        NotificationCenter.default.publisher(for: .fcmToken)
            .sink(receiveValue: { [weak self] notification in
                guard let fcmToken = notification.userInfo?["token"] as? String else {
                    return
                }
                
                self?.register(token: fcmToken)
            })
            .store(in: &cancellables)
    }
    
    /// Registers the given FCM token with the server asynchronously.
    ///
    /// This method creates a new `Task` to call the `service.register(fcmToken:)`
    /// function using Swift Concurrency. If an error occurs during registration,
    /// it is caught and printed to the console.
    ///
    /// - Parameter token:
    ///   The FCM token to be registered with the server.
    ///
    /// - Note:
    ///   - Any existing `task` will be overwritten with the new registration task.
    ///   - Errors are currently only logged via `print(_:)` and are not propagated.
    ///   - Consider adding error handling logic or user feedback in production.
    ///
    /// - SeeAlso:
    ///   - `service.register(fcmToken:)` for the actual network registration request.
    private func register(token: String) {        
        task = Task {
            do {
                try Task.checkCancellation()
                shouldNavigateToMain = try await service.register(fcmToken: token)
                
            } catch {
                print(error)
            }
        }
    }
}
