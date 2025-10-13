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
    var tokenUploadTask: Task<Void, Never>?
    
    var navigationFallbackTask: Task<Void, Never>?
    
    //MARK: - Methods
    
    /// Subscribes to FCM token notifications and handles token registration.
    ///
    /// This method listens for `.fcmToken` notifications posted via `NotificationCenter`.
    /// When a token is received, it calls `register(token:)` to register it with the server.
    ///
    /// Additionally, a fallback mechanism is implemented: if no token is received within 3 seconds,
    /// `shouldNavigateToMain` is set to `true` to allow navigation to the main screen.
    ///
    /// - Note: Uses Combine to store the subscription in `cancellables` and `[weak self]`
    ///         to avoid retain cycles.
    func subscribeToFCMToken() {
        NotificationCenter.default.publisher(for: .fcmToken)
            .sink(receiveValue: { [weak self] notification in
                guard let fcmToken = notification.userInfo?["token"] as? String else {
                    return
                }
                
                self?.register(token: fcmToken)
            })
            .store(in: &cancellables)
        
        // fallback: 3초 후에도 토큰이 전달되지 않으면 화면 전환
        navigationFallbackTask = Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            if !shouldNavigateToMain {
                shouldNavigateToMain = true
            }
        }
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
        tokenUploadTask = Task {
            do {
                try Task.checkCancellation()
                
                try await service.register(fcmToken: token)
                
                shouldNavigateToMain = true
                
            } catch {
                print(error)
            }
        }
    }
}
