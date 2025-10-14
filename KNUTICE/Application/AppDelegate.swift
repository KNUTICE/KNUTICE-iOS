//
//  AppDelegate.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/4/24.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import KNUTICECore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 학과 소식 알림 구독 기본값(최초 실행 시 true) 설정
        initializeMajorNotificationSubscriptionStatus()
        
        // FCM 세팅
        setFCM(application)
        
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
        
        if let filePath, let fileopts = FirebaseOptions(contentsOfFile: filePath) {
            FirebaseApp.configure(options: fileopts)
        }
        
        // UNUserNotificationCenter의 delegate를 AppDelegate class에서 처리하도록 설정
        UNUserNotificationCenter.current().delegate = self
        
        // 알림 권한 설정 및 알림 허용 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { granted, _ in
            // completion handler는 백그라운드 스레드에서 동작
            // 앱을 APNs를 통해 알림을 받도록 설정
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                
                NotificationCenter.default.post(
                    name: .didCompleteNotificationAuthorizationRequest,
                    object: nil,
                    userInfo: [UserInfoKeys.isNotificationAuthorizationCompleted.rawValue: true]
                )
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
        guard let value = userInfo["event"],
              let eventName = value as? String,
              let event = SilentPushEvent(rawValue: eventName) else {
            return
        }
        
        // 수신한 사일런트 푸시의 eventName이 token_update인 경우,
        // FCM 토큰을 서버에 업로드하는 비동기 작업을 실행.
        if event == .tokenUpdate {
            Task {
                do {
                    try await FCMTokenManager.shared.updateToken()
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
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
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
    
    // MARK: - Background Notification Handling
    
    //알림을 클릭했을 때 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        set(userInfo: response.notification.request.content.userInfo)
        completionHandler()
    }
    
    private func set(userInfo: [AnyHashable : Any]) {
        UserDefaults.standard.set(userInfo, forKey: UserDefaultsKeys.userInfo.rawValue)
    }
}

