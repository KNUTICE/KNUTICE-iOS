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
    
    /// 앱이 Actice 상태로 진입 후 앱 Bade Count를 초기화 한 후 남은 Notification Request에 대해 Badge Count 업데이트
    func updatePendingNotificationRequestsBadge() {
        //Badge Count 초기화
        self.resetBadgeCount()
        
        //새로운 Badge Count로 설정된 Notification Request 등록
        //동일한 identifier를 가지는 Request는 덮어씀
        self.createNotificationRequests { newRequests in
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
    
    ///Bookmark 수정 시 Notification Request의 Badge Count 수정
    func updateNotificationRequestsBadge() -> AnyPublisher<Void, any Error> {
        return Future { promise in
            //Badge Count 초기화
            self.resetBadgeCount()
            
            //새로운 Badge Count로 설정된 Notification Request 등록
            //동일한 identifier를 가지는 Request는 덮어씀
            self.createNotificationRequests { newRequests in
                newRequests.forEach {
                    self.add($0) { error in
                        if let error = error {
                            promise(.failure(error))
                        }
                    }
                }
                
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateNotificationRequestsBadgeAfterDeletion(by identifier: String) -> AnyPublisher<Void, any Error> {
        return Future { promise in
            //Badge Count 초기화
            self.resetBadgeCount()
            
            //삭제할 Notification Request는 필터링 후 나머지 Request에 대해 배지 Count 업데이트
            self.createNotificationRequests(filterIdentifier: identifier) { filteredRequests in
                filteredRequests.forEach {
                    self.add($0) { error in
                        if let error = error {
                            promise(.failure(error))
                        }
                    }
                }
                
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func resetBadgeCount() {
        self.setBadgeCount(0)
        UserDefaults.standard.set(0, forKey: "badgeCount")
    }
    
    private func createNotificationRequests(filterIdentifier: String? = nil,
                                            completionHandler: @escaping ([UNNotificationRequest]) -> Void) {
        self.getPendingNotificationRequests { requests in
            var newRequests = [UNNotificationRequest]()
            
            //삭제한 NotificationRequest는 필터링
            let filteredRequests = filterIdentifier != nil ? requests.filter { $0.identifier != filterIdentifier! } : requests
            
            //반환 하는 Request 배열은 날짜 순서를 보장하지 않음
            //알림 날짜 순서로 정렬
            let sortedRequests = filteredRequests.sorted {
                let lhs = $0.trigger as? UNCalendarNotificationTrigger
                let rhs = $1.trigger as? UNCalendarNotificationTrigger
                return lhs?.nextTriggerDate() ?? Date() < rhs?.nextTriggerDate() ?? Date()
            }
            
            sortedRequests.forEach { request in
                let content = self.createNotificationContent(body: request.content.body)
                let trigger = request.trigger
                let newRequest = UNNotificationRequest(identifier: request.identifier,
                                                       content: content,
                                                       trigger: trigger)
                newRequests.append(newRequest)
            }
            
            completionHandler(newRequests)
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
