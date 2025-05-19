import SwiftUI

class ContentViewModel : ObservableObject {
    @Published var showNotificationSettingsAlert: Bool = false
    
    // 알림 권한 요청 및 테스트 알림 예약
    func requestNotificationAuthorization() {
        NotificationManager.shared.requestAuthorization { granted in
            DispatchQueue.main.async {
                if granted {
                    print("알림 권한이 허용되었습니다.")
                    // 13:00
                    NotificationManager.shared.scheduleDailyNotification(
                        at: 13,
                        minute: 0,
                        title: "HUGGIT",
                        body: "\(UserInfo.gitName.isEmpty ? UserInfo.gitName : "개발자")님 좋은 하루에요 :)\n오늘도 1일 1커밋을 향해 달려볼까요?",
                        message: "", // message 없이 처리
                        imageName: nil,
                        identifier: "afternoonNotification",
                        isTest: false
                    )
                    // 22:00
                    NotificationManager.shared.scheduleDailyNotification(
                        at: 22,
                        minute: 0,
                        title: "HUGGIT",
                        body: "\(UserInfo.gitName.isEmpty ? UserInfo.gitName : "개발자")님 오늘도 수고 많았어요!\n커밋으로 하루를 마무리 해볼까요?",
                        message: "",
                        imageName: nil,
                        identifier: "eveningNotification",
                        isTest: false
                    )
                } else {
                    print("알림 권한이 거부되었습니다.")
                    self.showNotificationSettingsAlert = true
                }
            }
        }
    }
}
