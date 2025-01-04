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
        
        if let fcmToken {
            let repository = TokenRepositoryImpl(dataSource: RemoteDataSourceImpl.shared)
            
            repository.registerToken(token: fcmToken)
                .subscribe(
                    onNext: {
                        if $0 {
                            print("Successfully to save FCM Token")
                        } else {
                            print("Failed to save FCM Token")
                        }
                    }
                )
                .disposed(by: disposeBag)
        }
    }
}
