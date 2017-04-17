//
//  Niotifications.swift
//  fastFiles
//
//  Created by Adrian on 02.04.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import UserNotifications

extension DownloadViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.performSegue(withIdentifier: "Downloads", sender: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
