//
//  SceneDelegate.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/4/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Configure UIWindow
        guard let windowScen = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScen)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            let viewContoller = UINavigationController(rootViewController: ParentViewController())
            self.window?.rootViewController = viewContoller
        } else {
            self.window?.rootViewController = ParentViewController()
        }
        
        self.window?.makeKeyAndVisible()
        
        // Handle deep link from cold start (widget, url, etc.)
        guard let url = connectionOptions.urlContexts.first?.url else { return }
        
        handleDeepLink(url, delayIfNeeded: true)
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

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        handleDeepLink(url)
    }
    
    private func handleDeepLink(_ url: URL, delayIfNeeded: Bool = false) {
        guard let nttId = getNoticeId(from: url),
              let navigationController = window?.rootViewController as? UINavigationController else {
            return
        }
        
        let viewController = NoticeContentViewController(
            viewModel: NoticeContentViewModel(nttId: nttId)
        )
        
        if delayIfNeeded {
            // cold start 시 rootViewController 세팅이 끝나기 전에 push 하면 Loading 화면에서 멈춤
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                navigationController.pushViewController(viewController, animated: true)
            }
        } else {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    private func getNoticeId(from url: URL) -> Int? {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let queryItem = components.queryItems,
           let id = queryItem.first(where: { $0.name == "nttId" })?.value,
           let nttId = Int(id) {
            
            return nttId
        }
        
        return nil
    }
}
