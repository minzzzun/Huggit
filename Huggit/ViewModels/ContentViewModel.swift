import SwiftUI

class ContentViewModel : ObservableObject {
    @Published var isAppleLogined : Bool = false
    @Published var showNotificationSettingsAlert: Bool = false
    
    var defaults = UserDefaults.standard
    
    // 애플로그인 했는지 확인
    func checkAppleLogin(){
        let appleId = defaults.string(forKey: "appleId") ?? ""
        if appleId == ""  {
            isAppleLogined = false
        } else {
            isAppleLogined = true
        }
        
    }
    
    // 알림 권한 요청 및 테스트 알림 예약
    func requestNotificationAuthorization() {
        NotificationManager.shared.requestAuthorization { granted in
            DispatchQueue.main.async {
                if granted {
                    print("알림 권한이 허용되었습니다.")
                    // 테스트 알림
                    //                    NotificationManager.shared.scheduleDailyNotification(
                    //                        at: 13,
                    //                        minute: 0,
                    //                        title: "HUGGIT",
                    //                        body: "오늘 commit 하셨나요?",
                    //                        message: "",
                    //                        imageName: nil,
                    //                        identifier: "testNotification",
                    //                        isTest: true
                    //                    )
                    // 13:00
                    NotificationManager.shared.scheduleDailyNotification(
                        at: 13,
                        minute: 0,
                        title: "HUGGIT",
                        body: "오늘 commit 하셨나요?",
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
                        body: "오늘 commit 하셨나요?",
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
