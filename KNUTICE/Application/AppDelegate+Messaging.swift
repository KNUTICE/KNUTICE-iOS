//
//  AppDelegate+Messaging.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/3/24.
//

import FirebaseMessaging

extension AppDelegate: @MainActor MessagingDelegate {
    //FCM token 관련
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        guard let fcmToken else { return }
        
        // 토큰 갱신 이벤트를 NotificationCenter로 전파
        let dataDic: [String: String] = [UserInfoKeys.fcmToken.rawValue: fcmToken]
        NotificationCenter.default.post(
            name: Notification.Name.fcmToken,
            object: nil,
            userInfo: dataDic
        )
    }
}
