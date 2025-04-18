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
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        guard let fcmToken else { return }
        let dataDic: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(
            name: Notification.Name.fcmToken,
            object: nil,
            userInfo: dataDic
        )
    }
}
