//
//  NotificationManager.swift
//  Huggit
//
//  Created by Minhyeok Kim on 3/24/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() { }
    
    // MARK: - 권한 요청
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Notification authorization error: \(error.localizedDescription)")
                }
                completion(granted)
            }
        }
    }
    
    // MARK: - 알림 예약
    /// 지정된 시간에 매일 반복되는 알림을 예약합니다.
    /// - Parameters:
    ///   - hour: 24시간제 시 (예: 13 또는 22)
    ///   - minute: 분 (예: 0)
    ///   - title: 알림 제목
    ///   - body: 알림 내용
    ///   - message: 추가 메시지(여기서는 subtitle로 사용)
    ///   - imageName: 앱 번들 내에 포함된 이미지 파일 이름 (확장자 포함, 예: "sample.png")
    ///   - identifier: 알림 요청 식별자
    ///   - isTest: true이면 지정된 시간이 아닌 5초 후로 예약하여 테스트할 수 있습니다.
    func scheduleDailyNotification(
        at hour: Int,
        minute: Int,
        title: String,
        body: String,
        message: String,
        imageName: String? = nil,
        identifier: String = "dailyNotification",
        isTest: Bool = false
    ) {
        let center = UNUserNotificationCenter.current()
        
        // 알림 콘텐츠 구성
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        // 추가 메시지는 subtitle로 활용 (원하는대로 content.userInfo 등으로도 설정 가능)
        content.subtitle = message
        content.sound = .default
        
        // 이미지 첨부 (옵션)
        if let imageName = imageName,
           let imageURL = Bundle.main.url(forResource: imageName, withExtension: nil) {
            do {
                let attachment = try UNNotificationAttachment(identifier: "imageAttachment", url: imageURL, options: nil)
                content.attachments = [attachment]
            } catch {
                print("Error attaching image: \(error.localizedDescription)")
            }
        }
        
        // 트리거 설정: 테스트용이면 5초 후, 아니면 지정된 시간에 반복
        let trigger: UNNotificationTrigger
        if isTest {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        } else {
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        }
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}
