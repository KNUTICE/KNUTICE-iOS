//
//  AppDelegate.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/4/24.
//

import UIKit
import RxSwift
import CoreData
import SkeletonView
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //FCM 세팅
        setFCM(application)
        
        //Notification Permission 세팅
        if !UserDefaults.standard.bool(forKey: "isInitializedNotificationSettings") {
            setNotificationPermissions()
        }
        
        sleep(1)
        return true
    }
    
    private func setFCM(_ application: UIApplication) {
        var filePath: String?
        
        #if DEV
        filePath = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist")
        #else
        filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        #endif
        
        if let fileopts = FirebaseOptions(contentsOfFile: filePath!) {
            FirebaseApp.configure(options: fileopts)
        }
        
        //UNUserNotificationCenter의 delegate를 AppDelegate class에서 처리하도록 설정
        UNUserNotificationCenter.current().delegate = self
        
        //알림 권한 설정 및 알림 허용 권한 요청
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in
                //백그라운드 스레드에서 동작
                //UI 관련 Task는 메인 스레드에서 동작하도록 해야함
            }
        )

        //앱을 APNs를 통해 알림을 받도록 설정
        application.registerForRemoteNotifications()
        
        //FIRMessaging delegate 설정
        Messaging.messaging().delegate = self
    }
    
    private func setNotificationPermissions() {
        do {
            try LocalNotificationDataSourceImpl.shared.createDataIfNeeded()
        } catch {
            print(error)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken    //device token을 Firebase messaging에 등록
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //Foreground 알림 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
    }
    
    //Background 알림 설정
    //알림을 클릭했을 때 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
         completionHandler()
    }
}
