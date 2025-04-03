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
    /// 새로운 Bookmark 알림 생성
    func registerLocalNotification(for bookmark: Bookmark) -> AnyPublisher<Void, any Error> {
        return Future { promise in
            guard let date = bookmark.alarmDate else {
                //알람이 설정되지 않은 경우 즉시 반환
                promise(.success(()))
                return
            }
            
            Task {
                let count = await self.pendingNotificationRequests().count
                let content = self.createNotificationContent(body: bookmark.notice.title, badge: count + 1)
                
                //알림 시점에 대한 DateComponents 생성
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                
                //알림 시점, 반복 여부 설정
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                //알림 요청을 위한 Request 객체 생성
                let notificationRequest = UNNotificationRequest(identifier: String(bookmark.notice.id),
                                                    content: content,
                                                    trigger: trigger)
                
                do {
                    try await self.add(notificationRequest)
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// 앱이 Active 상태로 진입 후 앱 Bade Count를 초기화 한 후 남은 Notification Request에 대해 Badge Count 업데이트
    func updatePendingNotificationRequestsBadge() {
        //새로운 Badge Count로 설정된 Notification Request 등록
        //동일한 identifier를 가지는 Request는 덮어씀
        Task {
            await createNotificationRequests().forEach { request in
                add(request) { error in
                    if let error = error {
                        print("UNUserNotificationCenter.updatePendingNotificationRequestsBadge Error: \(error)")
                    } else {
                        print("Successfully reset pending notification requests.")
                    }
                }
            }
        }
    }
    
    ///Bookmark 수정 시 Notification Request의 Badge Count 수정
    func updatePendingNotificationRequestsBadge() -> AnyPublisher<Void, any Error> {
        return Future { promise in
            //새로운 Badge Count로 설정된 Notification Request 등록
            //동일한 identifier를 가지는 Request는 덮어씀
            Task {
                await self.createNotificationRequests().forEach { request in
                    self.add(request) { error in
                        if let error {
                            promise(.failure(error))
                        }
                    }
                }
                
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func createNotificationRequests() async -> [UNNotificationRequest] {
        let pendingNotificationRequests = await pendingNotificationRequests()
        let sortedNotificationRequests = pendingNotificationRequests.sorted {
            let lhs = $0.trigger as? UNCalendarNotificationTrigger
            let rhs = $1.trigger as? UNCalendarNotificationTrigger
            return lhs?.nextTriggerDate() ?? Date() < rhs?.nextTriggerDate() ?? Date()
        }
        var newNotificationRequests = [UNNotificationRequest]()
        sortedNotificationRequests.enumerated().forEach { (i, request) in
            let content = createNotificationContent(body: request.content.body, badge: i + 1)
            let newRequest = UNNotificationRequest(
                identifier: request.identifier,
                content: content,
                trigger: request.trigger
            )
            newNotificationRequests.append(newRequest)
        }
        
        return newNotificationRequests
    }
    
    private func createNotificationContent(body: String, badge: Int) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "북마크 알림"
        content.body = body
        content.sound = .default
        content.badge = badge as NSNumber
        
        return content
    }
    
    func removeNotificationRequest(with identifier: String) {
        let identifiers: [String] = [identifier]
        self.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}

public extension UNUserNotificationCenter {
    /// Remote Notification이 도착 후 Badge Count를 업데이트하는 메서드
    func updatePendingNotificationsBadge() async {
        let pendingNotificationRequests = await pendingNotificationRequests()
        guard !pendingNotificationRequests.isEmpty else { return }
        
        let deliveredNotifications = await deliveredNotifications()
        let count = deliveredNotifications.count + 1    //contentHandler가 호출될 때까지 count는 증가하지 않음
        
        pendingNotificationRequests.enumerated().forEach { (i, request) in
            let content = createNotificationContent(body: request.content.body, badge: count + 1 + i)
            let newRequest = UNNotificationRequest(
                identifier: request.identifier,
                content: content,
                trigger: request.trigger
            )
            
            self.add(newRequest)
        }
    }
}
