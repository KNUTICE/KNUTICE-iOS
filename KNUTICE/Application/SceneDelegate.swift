//
//  SceneDelegate.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/4/24.
//

import Combine
import KNUTICECore
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var pendingDeepLinkURL: URL?
    private var cancellables: Set<AnyCancellable> = []


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Configure UIWindow
        guard let windowScen = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScen)
        self.window?.rootViewController = UINavigationController(rootViewController: ParentViewController())
        self.window?.makeKeyAndVisible()
        
        // Observe the loading completion event to handle pending deep link navigation
        subscribeToDidFinishLoading()
        
        // Handle deep link from cold start (widget, url, etc.)
        guard let url = connectionOptions.urlContexts.first?.url else { return }
        
        // Stored for deep link navigation after entering the main screen.
        pendingDeepLinkURL = url
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        UNUserNotificationCenter.current().setBadgeCount(0)    //앱 아이콘 Badge 0으로 설정
        
        Task {
            await UNUserNotificationCenter.current().updatePendingNotificationsAfterForeground()    //스케줄링 되어 있는 알림 Badge 값 1씩 감소
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()    //전달된 모든 알림 데이터 삭제
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    /// Handles deep link navigation when the app is opened via a URL context.
    ///
    /// - Parameters:
    ///   - scene: The scene object associated with the app’s UI.
    ///   - URLContexts: A set of URL contexts that contain the URL used to open the app.
    ///                  Typically includes only one context with the incoming deep link URL.
    ///
    /// This method extracts the first URL from `URLContexts` and passes it to `handleDeepLink(_:)`
    /// to perform the actual navigation logic.
    /// Example: myapp://notice?nttId=123 will route the user to the notice detail screen.
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        handleDeepLink(url)
    }
    
    // FIXME: macOS(Designed for iPad)에서 NoticeDetailView 충돌 이슈
    private func handleDeepLink(_ url: URL) {
        Task { @MainActor [weak self] in            
            let deepLink = await DeepLinkManager.shared.parse(url)
            
            if let navigationController = self?.window?.rootViewController as? UINavigationController,
               case .notice(let nttId, _) = deepLink {
                let viewController = NoticeContentViewController(
                    viewModel: NoticeContentViewModel(nttId: nttId)
                )
                
//                if #available(iOS 26, *) {
//                    viewController = UIHostingController(
//                        rootView: NoticeDetailView()
//                            .environment(NoticeDetailViewModel(noticeId: nttId))
//                    )
//                } else {
//                    viewController = NoticeContentViewController(
//                        viewModel: NoticeContentViewModel(nttId: nttId)
//                    )
//                }
                
                navigationController.pushViewController(viewController, animated: true)
            }
        }
    }
    
    /// Subscribes to the `.didFinishLoading` notification to handle pending deep links after the loading process completes.
    ///
    /// This method observes the `Notification.Name.didFinishLoading` event emitted when the
    /// initial loading or splash process finishes. Once the notification is received,
    /// it checks if a pending deep link URL exists (`pendingDeepLinkURL`) and navigates to
    /// the corresponding destination using `handleDeepLink(_:)`.
    ///
    /// The subscription is stored in `cancellables` to manage its lifecycle properly.
    ///
    /// - Note: This ensures that deep link navigation occurs only after the app’s root
    ///   view hierarchy has been fully initialized, preventing navigation from being blocked
    ///   on the loading screen.
    private func subscribeToDidFinishLoading() {
        NotificationCenter.default.publisher(for: Notification.Name.didFinishLoading)
            .sink(receiveValue: { [weak self] _ in
                guard let url = self?.pendingDeepLinkURL else { return }
                
                self?.handleDeepLink(url)
            })
            .store(in: &cancellables)
    }
}

