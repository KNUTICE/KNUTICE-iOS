//
//  AppDelegate+Messaging.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/3/24.
//

import FirebaseMessaging

extension AppDelegate: MessagingDelegate {
    //FCM token 관련
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        // TODO: Firebase token을 서버로 전송
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
