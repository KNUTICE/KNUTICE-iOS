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
    @Injected(\.registerFCMTokenUseCase) private var registerFCMTokenUseCase
    
    /// A set of Combine cancellables used to store subscriptions for automatic cancellation
    /// when the owning instance is deallocated.
    private var cancellables: Set<AnyCancellable> = []
    
    /// The currently running async task for FCM token registration or related work.
    /// Cancelling or overwriting this task will stop the in-progress operation.
    var tokenUploadTask: Task<Void, Never>?
    
    var navigationFallbackTask: Task<Void, Never>?
    
    //MARK: - Methods
    
    /// Subscribes to FCM token update notifications and registers the new token when received.
    ///
    /// This method listens for `.fcmToken` notifications posted to `NotificationCenter`.
    /// When a notification is received, it extracts the token string from the `userInfo`
    /// dictionary and calls `register(token:)` to register it.
    ///
    /// - Note: The subscription is stored in the `cancellables` set to manage its lifecycle.
    func subscribeToFCMToken() {
        NotificationCenter.default.publisher(for: .fcmToken)
            .sink(receiveValue: { [weak self] notification in
                guard let fcmToken = notification.userInfo?[UserInfoKeys.fcmToken.rawValue] as? String else {
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
        tokenUploadTask = Task {
            do {
                try Task.checkCancellation()
                
                try await registerFCMTokenUseCase.execute(token: token)
                
                shouldNavigateToMain = true
                
            } catch {
                print(error)
            }
        }
    }
    
    /// Subscribes to changes in the notification authorization status.
    ///
    /// When the authorization becomes `true`, this method schedules a fallback
    /// navigation task. If a notification token is not received within 3 seconds
    /// after authorization is confirmed, the method automatically updates
    /// `shouldNavigateToMain` to trigger a navigation to the main view.
    ///
    /// This method also keeps the subscription alive using `cancellables`.
    ///
    /// Behavior:
    /// - Waits for `isAuthorized == true`.
    /// - Starts a 3-second timeout task.
    /// - If no token arrives within the window, triggers navigation fallback.
    /// - Intended to prevent the UI from stalling when FCM/APNS token callbacks are delayed.
    ///
    /// Notes:
    /// - TODO: Replace fallback with an alert, then navigate to the main view after user acknowledgment.
    /// - Uses `[weak self]` to prevent retain cycles.
    /// - Safe to call multiple times; Combine ensures multiple sinks do not interfere.
    ///
    func subscribeToNotificationAuthorizationStatus() {
        NotificationAuthorizationObservable.shared.publisher
            .sink(receiveValue: { [weak self] isAuthorized in
                guard isAuthorized else { return }
                
                // 알림 권한 확인 후, 3초 후에도 토큰이 전달되지 않으면 화면 전환
                // TODO: 경고 Alert 표시 후 메인 뷰로 이동하도록 변경
                self?.navigationFallbackTask = Task {
                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                    if self?.shouldNavigateToMain == false {
                        self?.shouldNavigateToMain = true
                    }
                }
            })
            .store(in: &cancellables)
    }
    
}
