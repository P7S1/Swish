//
//  NotificationsHelper.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/10/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//
import Firebase
import UIKit
import UserNotifications

class NotificationsHelper: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationsHelper()
    
     func registerForPushNotifications() {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self

        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
        self.scheduleNotificationForPollExpirationDate()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    static func removeFirestorePushToken(completion : @escaping (Error?) -> Void ){
        if let deviceID = UIDevice.current.identifierForVendor?.uuidString{
            ref.child("devices/\(User.shared!.uid)/\(deviceID)").removeValue { (error, ref) in
                completion(error)
            }
        }
    }
    
    private func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken,
            let deviceID = UIDevice.current.identifierForVendor?.uuidString{
            ref.child("devices/\(User.shared!.uid)/\(deviceID)").setValue(token) { (error, ref) in
                if error == nil{
                    print("successfully registered for push notificaitons")
                }else{
                    print("there was an error \(error!.localizedDescription)")
                }
            }
        }
    }
    
    func scheduleNotificationForPollExpirationDate(){
        if let user = User.shared {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Times up! 🔔"
            content.body = "You're next 12 questions are ready ✅"
            content.sound = .default
            let pollExpirationDate = user.getPollExpirationDate()
            let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: pollExpirationDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            let request = UNNotificationRequest(identifier: user.uid, content: content, trigger: trigger)
            center.add(request)
        }
    }
    
}
