//
//  3DTouch.swift
//  fastFiles
//
//  Created by Adrian on 19.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension AppDelegate {
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.localizedTitle == "iCloud" { // Open iCloud
            let _ = self.application(UIApplication.shared, open: App().iCloudDrive()!.urlScheme, options: [:])
        } else if shortcutItem.localizedTitle == "Documents" { // Open Documents
            let _ = self.application(UIApplication.shared, open: docsURL.urlScheme, options: [:])
        }
    }
}
