/*
 File: [NotificationPublisher.swift]
 Creators: [Jake]
 Date created: [30/11/2019]
 Date updated: [30/11/2019]
 Updater name: [Jake]
 File description: [Controls functionality for sending local notifications]
 */

import UIKit
import Foundation
import UserNotifications

class NotificationPublisher: NSObject {
    
    func Notification(title: String, subtitle: String, body: String, badge: Int?, delayInterval: Int?) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        
        var delayTimeTrigger: UNTimeIntervalNotificationTrigger?
        
        if let delayInterval = delayInterval {
            delayTimeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delayInterval), repeats: false)
        }
        
        if let badge = badge {
            var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            currentBadgeCount += badge
            content.badge = NSNumber(integerLiteral: currentBadgeCount)
        }
        
        content.sound = UNNotificationSound.default
        
        UNUserNotificationCenter.current().delegate = self
        
        let request = UNNotificationRequest(identifier: "medNotification", content: content, trigger: delayTimeTrigger)
        
        UNUserNotificationCenter.current().add(request) {error in
            if let error = error {
            print(error.localizedDescription)
            }
        }
    }

}

extension NotificationPublisher: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("The notification is about to be presented")
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.actionIdentifier
        
        switch identifier {
        case UNNotificationDismissActionIdentifier:
            print("Notification was dismissed")
            completionHandler()
        case UNNotificationDefaultActionIdentifier:
            print("User opened the app from the notification")
            completionHandler()
        default:
            print("The default case was called")
            completionHandler()
        }
    }
}
