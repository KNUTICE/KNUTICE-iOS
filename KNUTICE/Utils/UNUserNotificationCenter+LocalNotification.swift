//
//  UNUserNotificationCenter+LocalNotification.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/18/25.
//

import Combine
import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    func registerLocalNotification(for bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return Future { promise in
            guard let date = bookmark.alarmDate else {
                //알람이 설정되지 않은 경우 즉시 반환
                promise(.success(()))
                return
            }
            
            let content = self.createNotificationContent(body: bookmark.notice.title)
            
            //알림 시점에 대한 DateComponents 생성
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            
            //알림 시점, 반복 여부 설정
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            //알림 요청을 위한 Request 객체 생성
            let request = UNNotificationRequest(identifier: String(bookmark.notice.id),
                                                content: content,
                                                trigger: trigger)
            
            self.add(request) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func resetPendingNotificationRequests() {
        //Badge Count 초기화
        self.setBadgeCount(0)
        UserDefaults.standard.set(0, forKey: "badgeCount")
        
        //모든 Pending Request를 가져온 후 Badge Count 재설정
        self.getPendingNotificationRequests { requests in
            var newRequests = [UNNotificationRequest]()
            
            requests.forEach { request in
                let content = self.createNotificationContent(body: request.content.body)
                let trigger = request.trigger
                let request = UNNotificationRequest(identifier: request.identifier,
                                                    content: content,
                                                    trigger: trigger)
                
                newRequests.append(request)
            }
            
            //새로운 Badge Count로 설정된 Notification Request 등록
            //동일한 identifier를 가지는 Request는 덮어씀
            newRequests.forEach {
                self.add($0) { error in
                    if let error = error {
                        print("UNUserNotificationCenter.resetPendingNotificationRequests Error: \(error)")
                    } else {
                        print("Successfully reset pending notification requests.")
                    }
                }
            }
        }
    }
    
    private func createNotificationContent(body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        let badgeCount = UserDefaults.standard.integer(forKey: "badgeCount")
        UserDefaults.standard.set(badgeCount + 1, forKey: "badgeCount")
        content.title = "북마크 알림"
        content.body = body
        content.sound = .default
        content.badge = badgeCount + 1 as NSNumber
        
        return content
    }
    
    func removeNotificationRequest(with identifier: String) {
        let identifiers: [String] = [identifier]
        self.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
