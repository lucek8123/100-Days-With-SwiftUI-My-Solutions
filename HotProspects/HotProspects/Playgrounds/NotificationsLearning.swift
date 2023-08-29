//
//  NotificationsLearning.swift
//  HotProspects
//
//  Created by Lucek Krzywdzinski on 20/04/2022.
//

import SwiftUI
import UserNotifications

struct NotificationsLearning: View {
    var body: some View {
        VStack {
            Button("Request Premitions") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else {
                        print(error?.localizedDescription)
                    }
                }
            }
            
            Button("Schedule Notifications") {
                let content = UNMutableNotificationContent()
                content.title = "Feed the dogs"
                content.subtitle = "They look hungry"
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}

struct NotificationsLearning_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsLearning()
    }
}
