//
//  Notifications (SFTPTableViewController).swift
//  fastFiles
//
//  Created by Adrian on 15.04.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import UserNotifications

extension SFTPTableViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let _ = App().delegate().application(UIApplication.shared, open: App().delegate().docsURL.appendingPathComponent(notificationFile).urlScheme)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        notificationFile = notification.request.content.title
        completionHandler([.alert, .sound])
    }
}
