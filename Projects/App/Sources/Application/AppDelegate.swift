//
//  AppDelegate.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/4/24.
//

import ComposableArchitecture
import Factory
import Firebase
import FirebaseCore
import FirebaseMessaging
import KNDeepLink
import KNDomain
import KNUtility
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 학과 소식 알림 구독 기본값(최초 실행 시 true) 설정
        initializeMajorNotificationSubscriptionStatus()
        
        // FCM 세팅
        setFCM(application)
        
        // 의존성 설정
        setDependencies()
        
        Installations.installations().authToken { result, _ in
            print("Fiebase instance ID token is \(result?.authToken ?? "n/a")")
        }
        
        return true
    }
    
    private func initializeMajorNotificationSubscriptionStatus() {
        let key = UserDefaultsKeys.isMajorNotificationSubscribed.rawValue
        
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(true, forKey: key)
        }
    }
    
    private func setFCM(_ application: UIApplication) {
        #if DEV
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist")
        #else
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        #endif
        
        guard let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let fileopts = FirebaseOptions(contentsOfFile: filePath) else {
            print("❌ Firebase configuration file not found")
            return
        }
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure(options: fileopts)
            print("✅ FirebaseApp Configured")
        }
        
        // UNUserNotificationCenter의 delegate를 AppDelegate class에서 처리하도록 설정
        UNUserNotificationCenter.current().delegate = self
        
        // 알림 권한 설정 및 알림 허용 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { granted, _ in
            // completion handler는 백그라운드 스레드에서 동작
            // 앱을 APNs를 통해 알림을 받도록 설정
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                NotificationAuthorizationObservable.shared.send(true)
            }
        }
        
        //FIRMessaging delegate 설정
        Messaging.messaging().delegate = self
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken    //device token을 Firebase messaging에 등록
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Handling Silent Push Notifications
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        guard let value = userInfo[UserInfoKeys.notificationEvent.rawValue],
              let eventName = value as? String,
              let event = SilentPushEvent(rawValue: eventName) else {
            return
        }
        
        // 수신한 사일런트 푸시의 eventName이 token_update인 경우,
        // FCM 토큰을 서버에 업로드하는 비동기 작업을 실행.
        if event == .tokenUpdate {
            Task {
                do {
                    let updateFCMTokenUseCase = Container.shared.updateFCMTokenUseCase()
                    try await updateFCMTokenUseCase.execute()
                } catch {
                    print(error)
                }
            }
        }
        
        completionHandler(.noData)
    }
}

extension AppDelegate: @MainActor UNUserNotificationCenterDelegate {
    // MARK: - Foreground Notification Handling
    
    //알림을 터치하지 않아도 알림이 전달되면 호출
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.list, .banner, .sound])
        
        
        // 전달된 모든 알림 객체 삭제
        // 삭제하지 않으면 리모트 알림 Badge 값 불일치
        // ex: Foreground에서 리모트 알림 받은 후, Background 상태에서 Badge 불일치
        center.removeAllDeliveredNotifications()
        
        // Foreground 상태에서 Bookmark 알림 받는 경우, 남아 있는 Notification Request Badge 값 재설정
        // Foreground 상태에서 Remote 알림을 받는 경우 NotificationService에서 남아 있는 알림의 Badge 값을 증가 시킴
        Task {
            await center.updatePendingNotificationRequestBadges() as Void
        }
    }
    
    // MARK: - User notification tap handling
    
    // 알림을 클릭했을 때 호출
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        if let deepLinkStr = userInfo[UserInfoKeys.deepLink.rawValue] as? String,
           let url = URL(string: deepLinkStr) {
            // 알림 데이터를 DeepLinkManager의 Publisher로 전달하여 앱 내부에서 딥링크 처리
            DeepLinkManager.shared.notificationPublisher.send(url)
        }
        
        // 시스템에 알림 처리가 완료되었음을 알림
        completionHandler()
    }
}

extension AppDelegate {
    /// TCA Feature에서 사용하는 UseCase 의존성 설정
    ///
    /// - Feature와 Data 계층 간 직접 의존성을 제거하고
    /// - App 계층을 Composition Root로 활용하며
    /// - 테스트 시 Mock UseCase로 손쉽게 교체할 수 있다.
    ///
    /// - Note:
    ///   Feature 모듈 내부에서는 `liveValue`를 직접 구현하지 않고,
    ///   App 시작 시점에 `prepareDependencies`를 통해 실제 구현체를 등록한다.
    private func setDependencies() {
        prepareDependencies {
            $0.fetchBookmarkUseCase = Container.shared.fetchBookmarksUseCase()
            $0.deleteBookmarkUseCase = Container.shared.deleteBookmarkUseCase()
            $0.updateBookmarkUseCase = Container.shared.updateBookmarkUseCase()
            $0.saveBookmarkUseCase = Container.shared.saveBookmarkUseCase()
            $0.submitReportUseCase = Container.shared.submitReportUseCase()
            $0.fetchTopicSubscriptionUseCase = Container.shared.fetchTopicSubscriptionUseCase()
            $0.updateTopicSubscriptionUseCase = Container.shared.updateTopicSubscriptionUseCase()
        }
        
        Container.shared.fetchNoticeSummaryUseCase.register {
            FetchNoticeSummaryUseCaseImpl(repository: Container.shared.noticeSummaryRepository())
        }
        
        Container.shared.fetchNoticeSnapshotsUseCase.register {
            FetchNoticeSnapshotsUseCase(noticeRepository: Container.shared.noticeRepository())
        }
        
        Container.shared.searchNoticesUseCase.register {
            SearchNoticeSnapshotsUseCase(noticeRepository: Container.shared.noticeRepository())
        }
        
        Container.shared.searchBookmarksUseCase.register {
            SearchBookmarksUseCaseImpl(repository: Container.shared.bookmarkRepository())
        }
        
        Container.shared.fetchTipUseCase.register {
            FetchTipUseCaseImpl(repository: Container.shared.tipRepository())
        }
        
        Container.shared.fetchBookmarkUseCase.register {
            FetchBookmarksUseCaseImpl(bookmarkReportory: Container.shared.bookmarkRepository())
        }
        
        Container.shared.provideReloadEventPublisherUseCase.register {
            ProvideReloadEventPublisherUseCaseImpl(repository: Container.shared.bookmarkRepository())
        }
        
        Container.shared.deleteBookmarkUseCase.register {
            DeleteBookmarkUseCaseImpl(bookmarkRepository: Container.shared.bookmarkRepository())
        }
        
        Container.shared.fetchMajorCategoryUseCase.register {
            FetchSelectedMajorCategoryUseCase(repository: Container.shared.topicRepository())
        }
        
        Container.shared.fetchMajorCategoriesUseCase.register {
            FetchMajorCategoriesUseCase(repository: Container.shared.topicRepository())
        }
        
        Container.shared.addMajorUseCase.register {
            AddMajorUseCase(repository: Container.shared.topicSubscriptionRepository())
        }
        
        Container.shared.deleteMajorUseCase.register {
            DeleteMajorUseCase(repository: Container.shared.topicSubscriptionRepository())
        }
        
    }
}
